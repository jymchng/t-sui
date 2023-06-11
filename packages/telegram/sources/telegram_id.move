module telegram::telegram_id {
    use movemate::i64_type::{Self, I64};

    /// @dev `TelegramID` does not have `key` and `copy`
    struct TelegramID has store, drop {
        inner: I64,
    }

    public fun new(new_id: I64): TelegramID {
        TelegramID {
            inner: new_id
        }
    }

    public fun borrow(self: &TelegramID): &I64 {
        &self.inner
    }

    public fun mutate(self: &mut TelegramID, new_value: I64) {
        self.inner = new_value
    }

    public fun is_equal(self: &TelegramID, other: &TelegramID): bool {
        i64_type::compare(&self.inner, &other.inner) == 0
    }

}