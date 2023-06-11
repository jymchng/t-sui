module acct_abstract::account {
    use telegram::handle::{Handle};
    use telegram::telegram_id::{TelegramID};
    use sui::object::{UID};
    use sui::transfer;
    use std::option::{Self, Option};
    use sui::tx_context::{TxContext};

    /// @dev `Account` cannot be `drop`-ed.
    struct Account has key, store {
        id: UID,
        handle: Option<Handle>,
        tg_id: TelegramID
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

    public fun set_new_handle(self: &mut Account, new_handle: Handle) {
        option::fill(&mut self.handle, new_handle);
    }

    public fun mutate_handle(self: &mut Account, new_handle: Handle): Handle {
        let old_handle = option::swap(&mut self.handle, new_handle);
        old_handle
    }

    // Transferring

    public entry fun transfer_account(account: Account, recipient: address, _ctx: &mut TxContext) {
        transfer::transfer(account, recipient)
    }

}