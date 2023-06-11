module telegram::handle {
    use std::string::{Self, String};

    const EHandleInvalidLength: u64 = 0;

    /// @dev `TelegramID` does not have `key` and `copy`
    struct Handle has store, drop {
        inner: String,
    }

    public fun new(handle: String): Handle {
        assert!(string::length(&handle) > 4, EHandleInvalidLength);
        Handle {
            inner: handle
        }
    }

    public fun borrow(self: &Handle): &String {
        &self.inner
    }

    public fun mutate(self: &mut Handle, new_value: String) {
        assert!(string::length(&new_value) > 4, EHandleInvalidLength);
        self.inner = new_value
    }

    // public fun is_equal(self: &Handle, other: &Handle): bool {
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

    public fun is_equal(self: &Handle, other: &Handle): bool {
        &self.inner == &other.inner
    }







}