export const FreepaiDAO_Address = "0x9960cd7C0A0C353336780F69400F00cf"

export const getDaoPlugins = async () => {
    const installed_plugins_index = 1

    try {
        const rets = new Array();

        const freepaiDAO = await window.starcoin.request({
          method: 'contract.get_resource',
          params: [FreepaiDAO_Address, "0x9960cd7c0a0c353336780f69400f00cf::FreepaiDAO::FreepaiDAO"],
        });

        const plugins = freepaiDAO.value[installed_plugins_index][1].Vector
        for (const plugin in plugins) {
            const plugin_id = plugin.Struct.value[0][1].U64;
            const plugin_version_number = plugin.Struct.value[1][1].U64

            rets.push_back({
                plugin_id: plugin_id,
                plugin_version_number: plugin_version_number,
            })
        }

        return rets;
    } catch (error) {
        console.error(error);
    }

    return null
}