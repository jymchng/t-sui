module acct_abstract::interface {

    use acct_abstract::account::{Self, Account};
    use acct_abstract::registry::{Self, AccountRegistry};
    use std::option;
    use telegram::handle::{Self, Handle};
    use telegram::telegram_id::{Self, TelegramID};
    use sui::tx_context::{Self, TxContext};
    use std::string::{Self, String};
    use sui::transfer;
    use sui::object::{Self, ID};
    use movemate::i64_type::{Self, I64};
    use sui::event;

    // Events
    struct EventRemoved<phantom T> has copy, drop { id: ID }
    struct EventCreated<phantom T> has copy, drop { id: ID }
    struct EventTransferred<phantom T> has copy, drop { id: ID }

    // One-time Witness
    struct AccountOTW has drop {}

    // Errors
    const EAddressNotFound: u64 = 0;

    // ========== Interface ==========

    // Transferring

    /// Transfer an `Account` from `sender` of this transaction to `recipient`. Updates the `AccountRegistry` too.
    public entry fun transfer_account(account: Account, recipient: address, acct_reg: &mut AccountRegistry, ctx: &mut TxContext) {
        let sender = tx_context::sender(ctx);
        assert!(registry::contains(acct_reg, sender), EAddressNotFound);
        // Done asserting, safe to `remove` and `push_back` new address of owner
        let acct_id = account::id(&account);
        // Remove old address-account pairing
        let _ = registry::remove(acct_reg, sender);
        // Add new address-account pairing
        registry::push_back(acct_reg, recipient, acct_id);
        // Emit event of account transferred
        event::emit(EventTransferred<AccountOTW> { id: acct_id });
        // Transfer the account from sender to recipient
        transfer::public_transfer(account, recipient);
    }

    // Public Constructor

    /// Public constructor for creating new `Account`
    public entry fun new_account(handle: String, tg_id: u64, acct_reg: &AccountRegistry, ctx: &mut TxContext) {
        // Create new `TelegramID`
        let tg_id = telegram_id::new(i64_type::from(tg_id));
        // Create new `Handle` iff `handle: String` is not empty, i.e. there is a handle associated to the Telegram Account
        let handle = if (!string::is_empty(&handle)) {
            option::some(handle::new(handle))
        } else {
            option::none()
        };
        // Create new `Account`
        let acct = account::new(handle, tg_id, ctx);
        // Get the `UID` (global SUI ObjectID) of the `Account`
        let acct_id = account::id(&acct);
        // Emit event of `Account` creation
        event::emit(EventCreated<AccountOTW> { id: acct_id });
        // Transfer this `Account` to the caller of this public entry function
        transfer::public_transfer(acct, tx_context::sender(ctx));
    }
}