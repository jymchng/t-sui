module acct_abstract::account {
    use telegram::handle::{Self, TelegramHandle};
    use telegram::id::{Self, TelegramID};
    use sui::object::{Self, ID, UID};
    use sui::transfer;
    use std::option::{Self, Option};
    use sui::tx_context::{Self, TxContext};
    use movemate::i64_type::{Self, I64};
    use std::string::{Self, String};

    /// @dev `TelegramAccount` cannot be `drop`-ed.
    struct TelegramAccount has key, store {
        id: UID,
        handle: Option<TelegramHandle>,
        tg_id: TelegramID
    }

    /// Constructor
    public fun new(handle: Option<TelegramHandle>, tg_id: TelegramID, ctx: &mut TxContext): TelegramAccount {
        let id = object::new(ctx);
        TelegramAccount {
            id,
            handle,
            tg_id,
        }
    }

    /// CRUD - Viewing

    public fun uid(self: &TelegramAccount): &UID {
        &self.id
    }

    public fun id(self: &TelegramAccount): ID {
        object::uid_to_inner(&self.id)
    }

    public fun handle(self: &TelegramAccount): &TelegramHandle {
        option::borrow(&self.handle)
    }

    public fun tg_id(self: &TelegramAccount): &TelegramID {
        &self.tg_id
    }

    // CRUD - Updating

    /// Set a new `handle` of this `TelegramAccount`. To be used when initialize a new `TelegramAccount`.
    public fun set_new_handle(self: &mut TelegramAccount, new_handle: TelegramHandle) {
        option::fill(&mut self.handle, new_handle);
    }

    /// Change the `handle` of this `TelegramAccount` to another `TelegramHandle`.
    public fun mutate_handle(self: &mut TelegramAccount, new_handle: TelegramHandle): TelegramHandle {
        let old_handle = option::swap(&mut self.handle, new_handle);
        old_handle
    }

    

}