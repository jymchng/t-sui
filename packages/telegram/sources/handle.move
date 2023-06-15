module telegram::handle {
    use std::string::{Self, String};

    const ETelegramHandleInvalidLength: u64 = 0;

    /// @dev `TelegramID` does not have `key` and `copy`
    struct TelegramHandle has store, drop {
        inner: String,
    }

    public fun new(handle: String): TelegramHandle {
        assert!(string::length(&handle) > 4, ETelegramHandleInvalidLength);
        TelegramHandle {
            inner: handle
        }
    }

    /// Borrow the inner String of TelegramHandle
    public fun borrow(self: &TelegramHandle): &String {
        &self.inner
    }

    /// Mutate the inner String of TelegramHandle
    public fun mutate(self: &mut TelegramHandle, new_value: String) {
        assert!(string::length(&new_value) > 4, ETelegramHandleInvalidLength);
        self.inner = new_value
    }

    // public fun is_equal(self: &TelegramHandle, other: &TelegramHandle): bool {
    //     if (string::length(&self.inner) != string::length(&other.inner)) {
    //         return false
    //     };

    //     let length_of_vec = string::length(&self.inner);
    //     let self_bytes = string::bytes(&self.inner);
    //     let other_bytes = string::bytes(&other.inner);

    //     let i = 0;
    //     while (i <= length_of_vec) {
    //         if (vector::borrow(self_bytes, i) != vector::borrow(other_bytes, i)) {
    //             return false
    //         };
    //     };
    //     return true
    // }

    public fun is_equal(self: &TelegramHandle, other: &TelegramHandle): bool {
        &self.inner == &other.inner
    }







}