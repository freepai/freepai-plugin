module FreepaiDAO::FreepaiDAO {
    use StarcoinFramework::Signer;
    use StarcoinFramework::Errors;
    use StarcoinFramework::Vector;
    use StarcoinFramework::Option::{ Self, Option};
    use FreePlugin::PluginMarketplace;

    const CONTRACT_ACCOUNT:address = @FreepaiDAO;

    const ERR_ALREADY_INITIALIZED: u64 = 100;
    const ERR_NOT_CONTRACT_OWNER: u64 = 101;
    const ERR_NOT_FOUND_PLUGIN: u64 = 102;
    const ERR_EXPECT_PLUGIN_NFT: u64 = 103;
    const ERR_REPEAT_ELEMENT: u64 = 104;
    const ERR_PLUGIN_HAS_INSTALLED: u64 = 105;
    const ERR_PLUGIN_VERSION_NOT_EXISTS: u64 = 106;
    const ERR_PLUGIN_NOT_INSTALLED: u64 = 107;

    /// The info for DAO installed Plugin
    struct InstalledPluginInfo has store, drop {
        plugin_id: u64,
        plugin_version: u64,
        granted_caps: vector<u8>,
    }

    struct FreepaiDAO has key {
        name: vector<u8>,
        installed_plugins: vector<InstalledPluginInfo>
    }

    /// A type describing a capability. 
    struct CapType has copy, drop, store { code: u8 }

    /// Creates a install plugin capability type.
    public fun root_cap_type(): CapType { CapType{ code: 0 } }
    
    public fun initialize(sender: &signer) {
        assert!(Signer::address_of(sender)==CONTRACT_ACCOUNT, Errors::requires_address(ERR_NOT_CONTRACT_OWNER));
        assert!(!exists<FreepaiDAO>(Signer::address_of(sender)), Errors::already_published(ERR_ALREADY_INITIALIZED));

        move_to(sender, FreepaiDAO{
            name: b"FreepaiDAO",
            installed_plugins: Vector::empty<InstalledPluginInfo>(),
        });
    }

    
    /// Install plugin with DAOInstallPluginCap
    public fun install_plugin(sender: &signer, plugin_id:u64, plugin_version: u64, granted_caps: vector<u8>) acquires FreepaiDAO {
        assert!(Signer::address_of(sender)==CONTRACT_ACCOUNT, Errors::requires_address(ERR_NOT_CONTRACT_OWNER));
        assert!(PluginMarketplace::exists_plugin_version(plugin_id, plugin_version), Errors::invalid_state(ERR_PLUGIN_VERSION_NOT_EXISTS));
        assert_no_repeat(&granted_caps);
        
        let dao = borrow_global_mut<FreepaiDAO>(CONTRACT_ACCOUNT);
        assert!(!exists_installed_plugin(dao, plugin_id, plugin_version), Errors::already_published(ERR_PLUGIN_HAS_INSTALLED));
        
        Vector::push_back<InstalledPluginInfo>(&mut dao.installed_plugins, InstalledPluginInfo{
            plugin_id: plugin_id,
            plugin_version: plugin_version,
            granted_caps,
        });
    }

    /// Install plugin with DAOInstallPluginCap
    public fun uninstall_plugin(sender: &signer, plugin_id:u64, plugin_version: u64) acquires FreepaiDAO {
        assert!(Signer::address_of(sender)==CONTRACT_ACCOUNT, Errors::requires_address(ERR_NOT_CONTRACT_OWNER));

        let dao = borrow_global_mut<FreepaiDAO>(CONTRACT_ACCOUNT);
        let idx = find_by_plugin_id_and_version(&dao.installed_plugins, plugin_id, plugin_version);
        assert!(Option::is_some(&idx), Errors::already_published(ERR_PLUGIN_NOT_INSTALLED));

        let i = Option::extract(&mut idx);
        Vector::remove<InstalledPluginInfo>(&mut dao.installed_plugins, i);
    }

    /// Helpers
    /// ---------------------------------------------------

    fun assert_no_repeat<E>(v: &vector<E>) {
        let i = 1;
        let len = Vector::length(v);
        while (i < len) {
            let e = Vector::borrow(v, i);
            let j = 0;
            while (j < i) {
                let f = Vector::borrow(v, j);
                assert!(e != f, Errors::invalid_argument(ERR_REPEAT_ELEMENT));
                j = j + 1;
            };
            i = i + 1;
        };
    }

    fun find_by_plugin_id_and_version(
        c: &vector<InstalledPluginInfo>,
        plugin_id: u64, plugin_version: u64
    ): Option<u64> {
        let len = Vector::length(c);
        if (len == 0) {
            return Option::none()
        };
        let idx = len - 1;
        loop {
            let plugin = Vector::borrow(c, idx);
            if (plugin.plugin_id == plugin_id && plugin.plugin_version == plugin_version) {
                return Option::some(idx)
            };
            if (idx == 0) {
                return Option::none()
            };
            idx = idx - 1;
        }
    }

    fun exists_installed_plugin(dao: &FreepaiDAO, plugin_id: u64, plugin_version: u64): bool {
        let idx = find_by_plugin_id_and_version(&dao.installed_plugins, plugin_id, plugin_version);
        Option::is_some(&idx)
    }

}

module FreepaiDAO::FreepaiDAOScript {
    use FreepaiDAO::FreepaiDAO;

    public(script) fun initialize(sender: signer) {
        FreepaiDAO::initialize(&sender)
    }

    public(script) fun install_plugin(sender: signer, plugin_id:u64, plugin_version: u64, granted_caps: vector<u8>) {
        FreepaiDAO::install_plugin(&sender, plugin_id, plugin_version, granted_caps)
    }

    public(script) fun uninstall_plugin(sender: signer, plugin_id:u64, plugin_version: u64) {
        FreepaiDAO::uninstall_plugin(&sender, plugin_id, plugin_version)
    }
}