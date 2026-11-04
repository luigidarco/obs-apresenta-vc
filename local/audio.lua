local obs=obslua
local ffi=require('ffi')
ffi.cdef[[typedef bool (*df_audio_callback)(void*, const char*, const char*);void obs_enum_audio_monitoring_devices(df_audio_callback cb, void *data);]]
local lib=ffi.load('/Applications/OBS.app/Contents/Frameworks/libobs.framework/Versions/A/libobs')
local last,lastRefresh='',0
local outputs={}
local function refresh()
 outputs={{name='Padrão do sistema',id='default'}}
 local cb=ffi.cast('df_audio_callback',function(_,name,id)table.insert(outputs,{name=ffi.string(name),id=ffi.string(id)});return true end)
 lib.obs_enum_audio_monitoring_devices(cb,nil)
 cb:free()
 lastRefresh=os.time()
end
local function tick()
 local source=obs.obs_get_source_by_name('Studio - audio')
 if source==nil then return end
 local settings=obs.obs_source_get_settings(source)
 local request=obs.obs_data_get_string(settings,'request')
 local message=''
 if request~='' and request~=last then
  last=request
  local r=obs.obs_data_create_from_json(request)
  local id=obs.obs_data_get_string(r,'id');local name=obs.obs_data_get_string(r,'name')
  if id~='' then
   local ok=obs.obs_set_audio_monitoring_device(name,id)
   if ok then message='Saída de retorno atualizada.' else message='Não foi possível selecionar a saída.' end
  end
  obs.obs_data_release(r)
 end
 if os.time()-lastRefresh>15 then refresh() end
 local data=obs.obs_data_create();local arr=obs.obs_data_array_create()
 for _,device in ipairs(outputs)do local x=obs.obs_data_create();obs.obs_data_set_string(x,'name',device.name);obs.obs_data_set_string(x,'id',device.id);obs.obs_data_array_push_back(arr,x);obs.obs_data_release(x)end
 obs.obs_data_set_array(data,'outputs',arr);obs.obs_data_array_release(arr)
 obs.obs_data_set_string(data,'message',message)
 obs.obs_data_set_string(data,'ack',last)
 local update=obs.obs_data_create();obs.obs_data_set_string(update,'text',obs.obs_data_get_json(data));obs.obs_source_update(source,update)
 obs.obs_data_release(update);obs.obs_data_release(data);obs.obs_data_release(settings);obs.obs_source_release(source)
end
function script_description()return 'ApresentaVC — dispositivos de retorno do OBS.'end
function script_load(settings)refresh();obs.timer_add(tick,500)end
function script_unload()obs.timer_remove(tick)end
