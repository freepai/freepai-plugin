import { utils } from 'web3'

export const PluginMarketplace_Address = "0x7dA9Cd8048A4620fda9e22977750C517"

export const hexVectorToStringArray = (vec) => {
    let rets = new Array();
    for (const i in vec) {
        const item = utils.hexToString(vec[i].Bytes)
        rets.push(item)
    }
    return rets
}

export const getPluginInfo = async (plugin_id, version_id) => {
    const installed_plugins_index = 1

    try {
        const registry = await window.starcoin.request({
          method: 'contract.get_resource',
          params: [PluginMarketplace_Address, "0x7dA9Cd8048A4620fda9e22977750C517::PluginMarketplace::PluginRegistry"],
        });

        const plugins = registry.value[installed_plugins_index][1].Vector
        for (const i in plugins) {
            const plugin = plugins[i];
            
            const the_plugin_id = plugin.Struct.value[0][1].U64
            const the_plugin_name = utils.hexToString(plugin.Struct.value[1][1].Bytes);
            const the_plugin_desc = utils.hexToString( plugin.Struct.value[2][1].Bytes);
            const the_plugin_git_repo = utils.hexToString(plugin.Struct.value[3][1].Bytes);

            if (the_plugin_id == plugin_id) {
                const the_plugin_versions = plugin.Struct.value[5][1].Vector
                for (const j in the_plugin_versions) {
                    const version = the_plugin_versions[j];

                    const the_number = parseInt(version.Struct.value[0][1].U64);
                    const the_version = utils.hexToString(version.Struct.value[1][1].Bytes)
                    const requires_cap = hexVectorToStringArray(version.Struct.value[2][1].Vector);
                    const export_caps = hexVectorToStringArray(version.Struct.value[3][1].Vector);
                    const impl_extpoints = hexVectorToStringArray(version.Struct.value[4][1].Vector);
                    const depend_extpoints = hexVectorToStringArray(version.Struct.value[5][1].Vector);
                    const constact_module = utils.hexToString(version.Struct.value[6][1].Bytes);
                    const js_entry_uri = utils.hexToString(version.Struct.value[7][1].Bytes);
                    const create_at = parseInt(version.Struct.value[8][1].U64);

                    if (the_number == version_id) {
                        return {
                            id: the_plugin_id,
                            name: the_plugin_name,
                            desc: the_plugin_desc,
                            git_repo: the_plugin_git_repo,
                            version_number: the_number,
                            version: the_version,
                            requires_cap: requires_cap,
                            export_caps: export_caps,
                            impl_extpoints: impl_extpoints,
                            depend_extpoints: depend_extpoints,
                            constact_module: constact_module,
                            js_entry_uri: js_entry_uri,
                            create_at: create_at,
                        }
                    }
                }
            }
        }
    } catch (error) {
        console.error(error);
    }

    return null
}