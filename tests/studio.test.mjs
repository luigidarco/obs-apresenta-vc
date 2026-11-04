import test from 'node:test';import assert from 'node:assert/strict';import{validateStory}from'../lib/studio.ts';
const story={id:'a',title:'Pauta',description:'Contexto',media:[],automatic:false};

test('informativos aceitam acentos e duração personalizada, mas rejeitam duração inválida ou IDs duplicados',()=>{const base={...story,identifications:[{id:'p',name:'João da Conceição',role:'Repórter',duration:5}]};assert.doesNotThrow(()=>validateStory(base));assert.throws(()=>validateStory({...base,identifications:[{...base.identifications[0],duration:0}]}));assert.throws(()=>validateStory({...base,identifications:[base.identifications[0],base.identifications[0]]}));assert.throws(()=>validateStory({...base,identifications:[{...base.identifications[0],name:'   '}]}));});
