/*
module FreePlugin::ExtensionPoint {

    use StarcoinFramework::Timestamp;
    use StarcoinFramework::Signer;
    use StarcoinFramework::Errors;
    

    const ERR_ALREADY_INITIALIZED: u64 = 100;
    const ERR_NOT_CONTRACT_OWNER: u64 = 101;

    const CONTRACT_ACCOUNT:address = @FreePlugin;

    struct ExtensionPointRegistry has key, store  {
       next_id: u64,
    }

    struct ExtensionPoint has key, store  {
       id: u64,
       name: vector<u8>,
       describe: vector<u8>,
       protobuf: vector<u8>,
       created_at: u64,
    }

    fun next_extpoint_id(account: &signer): u64 acquires ExtensionPointRegistry {
        let owner = Signer::address_of(account);
        let extpoint_registry = borrow_global_mut<ExtensionPointRegistry>(owner);
        let extpoint_id = extpoint_registry.next_id;
        extpoint_registry.next_id = extpoint_id + 1;
        extpoint_id
    }

    public fun initialize(sender: &signer): () {
        let owner = Signer::address_of(sender);

        assert!(owner==CONTRACT_ACCOUNT, Errors::already_published(ERR_NOT_CONTRACT_OWNER));
        assert!(!exists<ExtensionPointRegistry>(owner), Errors::already_published(ERR_ALREADY_INITIALIZED));

        //move_to(sender, ExtensionPointRegistry{next_id: 1})
    }

    public fun registerExtensionPoint<ExtT>(account: &signer, name: vector<u8>, describe: vector<u8>, protobuf:vector<u8>): () acquires ExtensionPointRegistry {
        let extpoint_id = next_extpoint_id(account);

        move_to(account, ExtensionPoint{
            id: extpoint_id, 
            name: name, 
            describe: describe, 
            protobuf: protobuf, 
            created_at: Timestamp::now_milliseconds(),
        });
    }

    public fun initialize(_sender: &signer) {

    }
}


module FreePlugin::ExtensionPointScripts{
	use FreePlugin::ExtensionPoint;

	public(script) fun initialize(sender: &signer) {
		ExtensionPoint::initialize(sender);
	}
}
*/

module FreePlugin::ExtensionPoint {
    use StarcoinFramework::Signer;
    use StarcoinFramework::Errors;

    const CONTRACT_ACCOUNT:address = @FreePlugin;

    const ERR_ALREADY_INITIALIZED: u64 = 100;
    const ERR_NOT_CONTRACT_OWNER: u64 = 101;

    struct ExtensionPointRegistry has key, store  {
       next_id: u64,
    }

	public fun initialize(sender: &signer) {
        assert!(Signer::address_of(sender)==CONTRACT_ACCOUNT, 101);
        assert!(!exists<ExtensionPointRegistry>(Signer::address_of(sender)), Errors::already_published(ERR_ALREADY_INITIALIZED));

        move_to(sender, ExtensionPointRegistry{next_id: 1})
    }
}

module FreePlugin::ExtensionPointScripts{
	use FreePlugin::ExtensionPoint;

	public(script) fun initialize(sender: signer) {
		ExtensionPoint::initialize(&sender);
	}
}