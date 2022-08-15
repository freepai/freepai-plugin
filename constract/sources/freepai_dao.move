module FreepaiDAO::FreepaiDAO {
    use StarcoinFramework::Account::{Self, SignerCapability};
    use StarcoinFramework::Signer;
    use StarcoinFramework::Errors;
    use StarcoinFramework::Vector;

    const CONTRACT_ACCOUNT:address = @FreepaiDAO;

    const ERR_ALREADY_INITIALIZED: u64 = 100;
    const ERR_NOT_CONTRACT_OWNER: u64 = 101;
    const ERR_NOT_FOUND_PLUGIN: u64 = 102;
    const ERR_EXPECT_PLUGIN_NFT: u64 = 103;
    const ERR_REPEAT_ELEMENT: u64 = 104;
    const ERR_PLUGIN_HAS_INSTALLED: u64 = 105;

    /// The info for DAO installed Plugin
    struct InstalledPluginInfo has store {
        plugin_id: u64,
        plugin_version: u64,
        granted_caps: vector<CapType>,
    }

    struct FreepaiDAO has key {
        name: vector<u8>,
        installed_plugins: vector<InstalledPluginInfo>
    }

    /// A type describing a capability. 
    struct CapType has copy, drop, store { code: u8 }

    /// Creates a install plugin capability type.
    public fun root_cap_type(): CapType { CapType{ code: 0 } }

    struct DAORootCap has key, store {
        signer_cap: SignerCapability,
    }
    
    public(script) fun initialize(sender: signer) {
        assert!(Signer::address_of(&sender)==CONTRACT_ACCOUNT, Errors::requires_address(ERR_NOT_CONTRACT_OWNER));
        assert!(!exists<FreepaiDAO>(Signer::address_of(&sender)), Errors::already_published(ERR_ALREADY_INITIALIZED));

        let signer_cap = Account::remove_signer_capability(&sender);
        let dao_signer = Account::create_signer_with_cap(&signer_cap);

        move_to(&dao_signer, FreepaiDAO{
            name: b"FreepaiDAO",
            installed_plugins: Vector::empty<InstalledPluginInfo>(),
        });

        move_to(&dao_signer, DAORootCap{
            signer_cap: signer_cap,
        });
    }

    
    /// Install plugin with DAOInstallPluginCap
    public fun install_plugin(plugin_id:u64, plugin_version: u64, granted_caps: vector<CapType>) acquires FreepaiDAO {
        assert_no_repeat(&granted_caps);
        
        let dao = borrow_global_mut<FreepaiDAO>(CONTRACT_ACCOUNT);
        assert!(!exists_installed_plugin(dao, plugin_id, plugin_version), Errors::already_published(ERR_PLUGIN_HAS_INSTALLED));
        //TODO check plugin_id and plugin_version exist
        
        Vector::push_back<InstalledPluginInfo>(&mut dao.installed_plugins, InstalledPluginInfo{
            plugin_id: plugin_id,
            plugin_version: plugin_version,
            granted_caps,
        });
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

    fun exists_installed_plugin(dao: &FreepaiDAO, plugin_id: u64, plugin_version: u64): bool {
        let install_plugins = &dao.installed_plugins;
        let len = Vector::length(install_plugins);
        let i = 0;
        while (i < len) {
            let plugin = Vector::borrow(install_plugins, i);
            if (plugin.plugin_id == plugin_id && plugin.plugin_version == plugin_version) {
                return true
            };

            i = i + 1;
        };

        false
    }
}