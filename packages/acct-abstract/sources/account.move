module acct_abstract::account {
    use telegram::handle::{Handle};
    use telegram::telegram_id::{TelegramID};
    use sui::object::{Self, UID};
    use sui::transfer;
    use std::option::{Self, Option};
    use sui::tx_context::{TxContext};

    /// @dev `Account` cannot be `drop`-ed.
    struct Account has key, store {
        id: UID,
        handle: Option<Handle>,
        tg_id: TelegramID
    }

    // Constructor

    public fun new(handle: Option<Handle>, tg_id: TelegramID, ctx: &mut TxContext): Account {
        let id = object::new(ctx);
        Account {
            id,
            handle,
            tg_id,
        }
    }

    // CRUD - Viewing

    public fun id(self: &Account): &UID {
        &self.id
    }

    public fun handle(self: &Account): &Handle {
        option::borrow(&self.handle)
    }

    public fun tg_id(self: &Account): &TelegramID {
        &self.tg_id
    }

    // CRUD - Updating

    /// Set a new `handle` of this `Account`. To be used when initialize a new `Account`.
    public fun set_new_handle(self: &mut Account, new_handle: Handle) {
        option::fill(&mut self.handle, new_handle);
    }

    /// Change the `handle` of this `Account` to another `Handle`.
    public fun mutate_handle(self: &mut Account, new_handle: Handle): Handle {
        let old_handle = option::swap(&mut self.handle, new_handle);
        old_handle
    }

    // ========== Interface ==========

    // Public Constructor

    // public entry fun new_account(handle: String, tg_id: I64, ctx: &mut TxContext): Account {
    //     todo!()
    // } 

    // Transferring

    /// Transfer an `Account` from `sender` of this transaction to `recipient`.
    public entry fun transfer_account(account: Account, recipient: address, _ctx: &mut TxContext) {
        transfer::transfer(account, recipient)
    }

}