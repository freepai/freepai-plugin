module FreePlugin::ExtensionPoint {
    use StarcoinFramework::CoreAddresses;
    use StarcoinFramework::Timestamp;
    use StarcoinFramework::Signer;
    use StarcoinFramework::Errors;
    

    const ERR_ALREADY_INITIALIZED: u64 = 100;

    struct ExtensionPointRegistry has key {
       next_id: u64,
    }

    struct ExtensionPoint has key {
       id: u64,
       name: vector<u8>,
       describe: vector<u8>,
       protobuf: vector<u8>,
       created_at: u64,
    }

    public(script) fun initialize(account: &signer) {
        let address = Signer::address_of(account);
        assert!(!exists<ExtensionPointRegistry>(address), Errors::already_published(ERR_ALREADY_INITIALIZED));

        move_to(account, ExtensionPointRegistry{next_id: 1})
    }

    public(script) fun registerExtensionPoint<ExtT>(account: &signer, name: vector<u8>, describe: vector<u8>, protobuf:vector<u8>): u64 acquires ExtensionPointRegistry {
        let extpoint_id = next_extpoint_id();

        move_to(account, ExtensionPoint{
            id: extpoint_id, 
            name: name, 
            describe: describe, 
            protobuf: protobuf, 
            created_at: Timestamp::now_milliseconds(),
        });

        extpoint_id
    }

    fun next_extpoint_id(): u64 acquires ExtensionPointRegistry {
        let extpoint_registry = borrow_global_mut<ExtensionPointRegistry>(CoreAddresses::GENESIS_ADDRESS());
        let extpoint_id = extpoint_registry.next_id;
        extpoint_registry.next_id = extpoint_id + 1;
        extpoint_id
    }
}