module FreepaiDAO::ProposalPlugin {
    use StarcoinFramework::Signer;
    use StarcoinFramework::Errors;
    use StarcoinFramework::Vector;
    use FreePlugin::PluginMarketplace;
    use FreepaiDAO::FreepaiDAO;

    const PLUGIN_ID: u64 = 1;
    const CONTRACT_ACCOUNT:address = @FreepaiDAO;

    const ERR_ALREADY_INITIALIZED: u64 = 100;
    const ERR_NOT_CONTRACT_OWNER: u64 = 101;
    const ERR_NOT_FOUND_PLUGIN: u64 = 102;
    const ERR_EXPECT_PLUGIN_NFT: u64 = 103;

    struct ProposalPlugin<phantom DaoT: key> has key {
         
    }

    public fun setup<DaoT: key>(sender: &signer) {
        move_to(sender, ProposalPlugin<DaoT>{});
    }

    public fun teardown(sender: &signer) {
 
    }

    public(script) fun initialize(sender: signer) {
        assert!(Signer::address_of(&sender)==CONTRACT_ACCOUNT, Errors::requires_address(ERR_NOT_CONTRACT_OWNER));
        
        let vec = Vector::empty<vector<u8>>();
        Vector::push_back<vector<u8>>(&mut vec, b"member_manager_plugin");
        PluginMarketplace::publish_plugin_version(
            &sender, 
            PLUGIN_ID,
            b"v0.1.0", 
            *&vec, 
            *&vec, 
            *&vec, 
            *&vec, 
            b"0x1::PluginA", 
            b"ipfs:://xxxxxx"
        );
    }
}