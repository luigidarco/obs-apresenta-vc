import {defineConfig}from'vite';import react from'@vitejs/plugin-react';export default defineConfig({plugins:[react()],root:'local-ui',build:{outDir:'../dist-local',emptyOutDir:true}});
