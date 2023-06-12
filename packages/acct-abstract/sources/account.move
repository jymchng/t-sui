module acct_abstract::account {
    use telegram::handle::{Self, Handle};
    use telegram::telegram_id::{Self, TelegramID};
    use sui::object::{Self, ID, UID};
    use sui::transfer;
    use std::option::{Self, Option};
    use sui::tx_context::{Self, TxContext};
    use movemate::i64_type::{Self, I64};
    use std::string::{Self, String};

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

    public fun uid(self: &Account): &UID {
        &self.id
    }

    public fun id(self: &Account): ID {
        object::uid_to_inner(&self.id)
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

    

}