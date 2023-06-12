module acct_abstract::registry {
    use telegram::handle::{Self, Handle};
    use telegram::telegram_id::{Self, TelegramID};
    use sui::object::{Self, UID, ID};
    use sui::transfer;
    use std::option::{Self, Option};
    use sui::tx_context::{Self, TxContext};
    use movemate::i64_type::{Self, I64};
    use std::string::{Self, String};
    use sui::event;
    use sui::linked_table::{Self, LinkedTable};

    friend acct_abstract::interface;

    struct AccountRegistry has key {
        id: UID,
        table: LinkedTable<address, ID>
    }

    // CRUD - only usable to the `interface` module

    public(friend) fun contains(self: &AccountRegistry, k: address): bool {
        linked_table::contains(&self.table, k)
    }

    public(friend) fun borrow_mut(self: &mut AccountRegistry, k: address): &mut ID {
        linked_table::borrow_mut(&mut self.table, k)
    }

    public(friend) fun push_back(self: &mut AccountRegistry, k: address, v: ID) {
        linked_table::push_back(&mut self.table, k, v)
    }

    public(friend) fun remove(self: &mut AccountRegistry, k: address): ID {
        linked_table::remove(&mut self.table, k)
    }
}