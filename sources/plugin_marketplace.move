module FreePlugin::PluginMarketplace {
    use StarcoinFramework::Signer;
    use StarcoinFramework::Errors;
    use StarcoinFramework::Timestamp;
    use StarcoinFramework::Vector;
    use StarcoinFramework::NFT;
    use StarcoinFramework::NFTGallery;
    use StarcoinFramework::Option::{ Self, Option};

    const CONTRACT_ACCOUNT:address = @FreePlugin;

    const ERR_ALREADY_INITIALIZED: u64 = 100;
    const ERR_NOT_CONTRACT_OWNER: u64 = 101;
    const ERR_NOT_FOUND_PLUGIN: u64 = 102;
    const ERR_EXPECT_PLUGIN_NFT: u64 = 103;

    struct PluginVersion has store, copy, drop {
        number: u64, //Numeric version number, such as 1, 2, 3
        version: vector<u8>, //Plugin version number, e.g. v0.1.1
        required_caps: vector<vector<u8>>, //ability to depend
        export_caps: vector<vector<u8>>, //ability to export
        implement_extpoints: vector<vector<u8>>, //Implemented extension points
        depend_extpoints: vector<vector<u8>>, //Dependent extension points
        contract_module: vector<u8>, //Contract module, format: ${address}::${module}
        js_entry_uri: vector<u8>, //Front-end JS code resource URI, for example: "https://cdn.xxxx.xxxx/xxxx/xxxxx.js"
        created_at: u64, //Plugin creation time
    }
    
    struct Star has store, copy, drop {
        addr: address, //Star's wallet address, which can be a short address, such as zhangsan.stc
        created_at: u64, //creation time
    }
    
    struct Comment has store, copy, drop {
        addr: address, //The commenter's wallet address, which can be a short address, such as zhangsan.stc
        content: vector<u8>, //comments
        created_at: u64, //creation time
    }
    
    struct PluginInfo has store {
        id: u64, //Plugin ID
        name: vector<u8>, //plugin name
        describe: vector<u8>, //Plugin description
        git_repo: vector<u8>, //git repository code
        next_version_number: u64, //next version number
        versions: vector<PluginVersion>, //All versions of the plugin
        stars: vector<Star>,//All stars of the plugin
        comments: vector<Comment>, //All comments for plugins
        created_at: u64, //Plugin creation time
        update_at: u64, //Plugin last update time
    }

    struct PluginRegistry has key, store {
        next_plugin_id: u64,
        plugins: vector<PluginInfo>,
    }

    /// Plugin Owner NFT
    struct PluginOwnerNFTMeta has copy, store, drop {
        plugin_id: u64,
        registry_address: address,
    }

    struct PluginOwnerNFTBody has store{}

    struct PluginOwnerNFTMintCapHolder has key {
        cap: NFT::MintCapability<PluginOwnerNFTMeta>,
        nft_metadata: NFT::Metadata,
    }

    fun next_plugin_id(): u64 acquires PluginRegistry {
        let plugin_registry = borrow_global_mut<PluginRegistry>(CONTRACT_ACCOUNT);
        let plugin_id = plugin_registry.next_plugin_id;
        plugin_registry.next_plugin_id = plugin_id + 1;
        plugin_id
    }

    fun next_plugin_version_number(plugin: &mut PluginInfo): u64 {
        let version_number = plugin.next_version_number;
        plugin.next_version_number = version_number + 1;
        version_number
    }

    fun find_by_id(
        c: &vector<PluginInfo>,
        id: u64
    ): Option<u64> {
        let len = Vector::length(c);
        if (len == 0) {
            return Option::none()
        };
        let idx = len - 1;
        loop {
            let plugin = Vector::borrow(c, idx);
            if (plugin.id == id) {
                return Option::some(idx)
            };
            if (idx == 0) {
                return Option::none()
            };
            idx = idx - 1;
        }
    }

    fun has_plugin_nft(sender_addr: address, plugin_id: u64): bool {
        if (!exists<NFTGallery<PluginOwnerNFTMeta, PluginOwnerNFTBody>>(sender_addr)) {
            return false
        };
        let id_nft = borrow_global<IdentifierNFT<NFTMeta, NFTBody>>(owner);
        Option::is_some(&id_nft.nft)
    }

    fun ensure_plugin_nft(sender_addr: address, plugin_id: u64) {
        assert!(has_plugin_nft(sender_addr, plugin_id), Errors::invalid_state(ERR_EXPECT_PLUGIN_NFT));
    }


    public(script) fun initialize(sender: signer) {
        assert!(Signer::address_of(&sender)==CONTRACT_ACCOUNT, Errors::requires_address(ERR_NOT_CONTRACT_OWNER));
        assert!(!exists<PluginRegistry>(Signer::address_of(&sender)), Errors::already_published(ERR_ALREADY_INITIALIZED));

        let nft_name = b"FEP";
        let nft_image = b"SVG image";
        let nft_description = b"SVG image";
        let basemeta = NFT::new_meta_with_image_data(nft_name, nft_image, nft_description);
        let basemeta_bak = *&basemeta;
        NFT::register_v2<PluginOwnerNFTMeta>(&sender, basemeta);
        let nft_mint_cap = NFT::remove_mint_capability<PluginOwnerNFTMeta>(&sender);
        move_to(&sender, PluginOwnerNFTMintCapHolder{
            cap: nft_mint_cap,
            nft_metadata: basemeta_bak,
        });

        move_to(&sender, PluginRegistry{
            next_plugin_id: 1,
            plugins: Vector::empty<PluginInfo>(),
        });
    }

    public(script) fun register_plugin(sender: signer, name: vector<u8>, describe: vector<u8>) acquires PluginRegistry, PluginOwnerNFTMintCapHolder {
        let plugin_id = next_plugin_id();
        let plugin_registry = borrow_global_mut<PluginRegistry>(CONTRACT_ACCOUNT);

        Vector::push_back<PluginInfo>(&mut plugin_registry.plugins, PluginInfo{
            id: plugin_id, 
            name: name, 
            describe: describe,
            git_repo: Vector::empty<u8>(),
            next_version_number: 1,
            versions: Vector::empty<PluginVersion>(), 
            stars: Vector::empty<Star>(),
            comments: Vector::empty<Comment>(),
            created_at: Timestamp::now_milliseconds(),
            update_at: Timestamp::now_milliseconds(),
        });

        // grant owner NFT to sender
        let nft_mint_cap = borrow_global_mut<PluginOwnerNFTMintCapHolder>(CONTRACT_ACCOUNT);
        let meta = PluginOwnerNFTMeta{
            registry_address: CONTRACT_ACCOUNT,
            plugin_id: plugin_id,
        };

        let nft = NFT::mint_with_cap_v2(CONTRACT_ACCOUNT, &mut nft_mint_cap.cap, *&nft_mint_cap.nft_metadata, meta, PluginOwnerNFTBody{});
        NFTGallery::deposit(&sender, nft);
    }

    public(script) fun publish_plugin_version(sender: signer, plugin_id:u64, version: PluginVersion) acquires PluginRegistry {
        ensure_plugin_nft(sender, plugin_id);

        let plugin_registry = borrow_global_mut<PluginRegistry>(CONTRACT_ACCOUNT);

        let idx = find_by_id(&plugin_registry.plugins, plugin_id);
        assert!(Option::is_some(&idx), Errors::invalid_argument(ERR_NOT_FOUND_PLUGIN));

        let i = Option::extract(&mut idx);
        let plugin = Vector::borrow_mut<PluginInfo>(&mut plugin_registry.plugins, i);
        
        let version_number = next_plugin_version_number(plugin);
        Vector::push_back<PluginVersion>(&mut plugin.versions, PluginVersion{
            number: version_number,
            version: version.version,
            required_caps: version.required_caps,
            export_caps: version.export_caps,
            implement_extpoints: version.implement_extpoints,
            depend_extpoints: version.depend_extpoints,
            contract_module: version.contract_module,
            js_entry_uri: version.js_entry_uri,
            created_at: Timestamp::now_milliseconds(),
        });
    }
}
