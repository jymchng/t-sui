module acct_abstract::interface {

    use acct_abstract::account::{Self, TelegramAccount};
    use acct_abstract::registry::{Self, AccountRegistry};
    use std::option;
    use telegram::handle::{Self, TelegramHandle};
    use telegram::id::{Self, TelegramID};
    use sui::tx_context::{Self, TxContext};
    use std::string::{Self, String};
    use sui::transfer;
    use sui::object::{Self, ID};
    use movemate::i64_type::{Self, I64};
    use sui::event;
    use sui::package;

    // Events
    struct EventRemoved<phantom T> has copy, drop { id: ID }
    struct EventCreated<phantom T> has copy, drop { id: ID }
    struct EventTransferred<phantom T> has copy, drop { id: ID }

    // One-time Witness
    struct INTERFACE has drop {}

    // Event Phantom Structs
    struct TelegramAccountEvent has drop {}

    // Errors
    const EAddressNotFound: u64 = 0;

    /// Module Initializer
    fun init(otw: INTERFACE, ctx: &mut TxContext) {

    }

    // ========== Interface ==========

    // Transferring

    /// Transfer an `TelegramAccount` from `sender` of this transaction to `recipient`. Updates the `AccountRegistry` too.
    public entry fun transfer_account(account: TelegramAccount, recipient: address, acct_reg: &mut AccountRegistry, ctx: &mut TxContext) {
        let sender = tx_context::sender(ctx);
        assert!(registry::contains(acct_reg, sender), EAddressNotFound);
        // Done asserting, safe to `remove` and `push_back` new address of owner
        let acct_id = account::id(&account);
        // Remove old address-account pairing
        let _ = registry::remove(acct_reg, sender);
        // Add new address-account pairing
        registry::push_back(acct_reg, recipient, acct_id);
        // Emit event of account transferred
        event::emit(EventTransferred<TelegramAccountEvent> { id: acct_id });
        // Transfer the account from sender to recipient
        transfer::public_transfer(account, recipient);
    }

    // Public Constructor

    /// Public constructor for creating new `TelegramAccount`. Updates the `AccountRegistry` too.
    public entry fun new_account(handle: String, tg_id: u64, acct_reg: &mut AccountRegistry, ctx: &mut TxContext) {
        // Create new `TelegramID`
        let tg_id = id::new(i64_type::from(tg_id));
        // Create new `TelegramHandle` iff `handle: String` is not empty, i.e. there is a handle associated to the Telegram TelegramAccount
        let handle = if (!string::is_empty(&handle)) {
            option::some(handle::new(handle))
        } else {
            option::none()
        };
        // Create new `TelegramAccount`
        let acct = account::new(handle, tg_id, ctx);
        // Get the `UID` (global SUI ObjectID) of the `TelegramAccount`
        let acct_id = account::id(&acct);
        // Get `sender` of this transaction
        let sender = tx_context::sender(ctx);
        // Add new address-account pairing
        registry::push_back(acct_reg, sender, acct_id);
        // Emit event of `TelegramAccount` creation
        event::emit(EventCreated<TelegramAccountEvent> { id: acct_id });
        // Transfer this `TelegramAccount` to the caller of this public entry function
        transfer::public_transfer(acct, sender);
    }
}