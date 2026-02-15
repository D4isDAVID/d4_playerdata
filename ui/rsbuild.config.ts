import { defineConfig } from '@rsbuild/core';
import { pluginReact } from '@rsbuild/plugin-react';
import PostCssPresetMantine from 'postcss-preset-mantine';

export default defineConfig({
    tools: {
        postcss(_, { addPlugins }) {
            addPlugins([PostCssPresetMantine()]);
        },
    },
    plugins: [pluginReact()],
});
