module FreePlugin::ExtensionPoint {
    use StarcoinFramework::Signer;
    use StarcoinFramework::Errors;
    use StarcoinFramework::Timestamp;
    use StarcoinFramework::Vector;
    use StarcoinFramework::NFT;
    use StarcoinFramework::NFTGallery;

    const CONTRACT_ACCOUNT:address = @FreePlugin;

    const ERR_ALREADY_INITIALIZED: u64 = 100;
    const ERR_NOT_CONTRACT_OWNER: u64 = 101;

    struct ExtensionPoint has key, store  {
       id: u64,
       name: vector<u8>,
       describe: vector<u8>,
       protobuf: vector<u8>,
       created_at: u64,
    }

    struct Registry has key, store  {
       next_id: u64,
       items: vector<ExtensionPoint>,
    }

    struct RegistryEntry has copy, store, drop {
        extpoint_id: u64,
        registry_address: address,
    }

    struct NFTBody has store{}

    struct NFTMintCapHolder has key {
        cap: NFT::MintCapability<RegistryEntry>,
        nft_metadata: NFT::Metadata,
    }

    fun next_extpoint_id(): u64 acquires Registry {
        let extpoint_registry = borrow_global_mut<Registry>(CONTRACT_ACCOUNT);
        let extpoint_id = extpoint_registry.next_id;
        extpoint_registry.next_id = extpoint_id + 1;
        extpoint_id
    }

	public(script) fun initialize(sender: signer) {
        assert!(Signer::address_of(&sender)==CONTRACT_ACCOUNT, Errors::requires_address(ERR_NOT_CONTRACT_OWNER));
        assert!(!exists<Registry>(Signer::address_of(&sender)), Errors::already_published(ERR_ALREADY_INITIALIZED));

        let nft_name = b"FEP";
        let nft_image = b"SVG image";
        let nft_description = b"SVG image";
        let basemeta = NFT::new_meta_with_image_data(nft_name, nft_image, nft_description);
        let basemeta_bak = *&basemeta;
        NFT::register_v2<RegistryEntry>(&sender, basemeta);
        let nft_mint_cap = NFT::remove_mint_capability<RegistryEntry>(&sender);
        move_to(&sender, NFTMintCapHolder{
            cap: nft_mint_cap,
            nft_metadata: basemeta_bak,
        });

        move_to(&sender, Registry{
            next_id: 1,
            items: Vector::empty<ExtensionPoint>(),
        });
    }

    public(script) fun register(sender: signer, name: vector<u8>, describe: vector<u8>, protobuf:vector<u8>) acquires Registry, NFTMintCapHolder {
        let extpoint_id = next_extpoint_id();

        let extpoint_registry = borrow_global_mut<Registry>(CONTRACT_ACCOUNT);
        Vector::push_back<ExtensionPoint>(&mut extpoint_registry.items, ExtensionPoint{
            id: extpoint_id, 
            name: name, 
            describe: describe, 
            protobuf: protobuf, 
            created_at: Timestamp::now_milliseconds(),
        });

        // grant owner NFT to sender


        let nft_mint_cap = borrow_global_mut<NFTMintCapHolder>(CONTRACT_ACCOUNT);
        let meta = RegistryEntry{
            registry_address: CONTRACT_ACCOUNT,
            extpoint_id: extpoint_id,
        };

        let nft = NFT::mint_with_cap_v2(CONTRACT_ACCOUNT, &mut nft_mint_cap.cap, *&nft_mint_cap.nft_metadata, meta, NFTBody{});
        NFTGallery::deposit(&sender, nft);
    }
}
