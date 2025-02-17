module transaction_arguments::tx_args_module {
    use std::string;
    use std::error;
    use std::signer;
    use std::vector;
    use std::option::{Self, Option};
    use std::object::{Self, Object};
    use std::string::String;
    use std::type_info::{Self};

    /// The vector lengths are not equal.
    const INCORRECT_VECTOR_LENGTH: u64 = 100;
    /// The inner vector values are not equal.
    const VECTOR_VALUES_NOT_EQUAL: u64 = 200;
    /// Option 1 is none and Option 2 isn't.
    const OPTION_EQUALITY_ERROR_0: u64 = 300;
    /// Option 1 is some and Option 2 isn't.
    const OPTION_EQUALITY_ERROR_1: u64 = 400;
    /// Option 1 contains a different value than Option 2.
    const OPTION_EQUALITY_ERROR_2: u64 = 500;

    const MAX_U8: u8 = 255;
    const MAX_U16: u16 = 65535;
    const MAX_U32: u32 = 4294967295;
    const MAX_U64_BIG: u64 = 18446744073709551615;
    const MAX_U128_BIG: u128 = 340282366920938463463374607431768211455;
    const MAX_U256_BIG: u256 = 115792089237316195423570985008687907853269984665640564039457584007913129639935;

    const EXPECTED_BOOL: bool = true;
    const EXPECTED_U8: u8 = 1;
    const EXPECTED_U16: u16 = 2;
    const EXPECTED_U32: u32 = 3;
    const EXPECTED_U64: u64 = 4;
    const EXPECTED_U128: u128 = 5;
    const EXPECTED_U256: u256 = 6;
    const EXPECTED_ADDRESS: address = @transaction_arguments;
    const EXPECTED_STRING: vector<u8> = b"expected_string";

    const EXPECTED_VECTOR_BOOL: vector<bool> = vector<bool> [ true, false, true ];
    // the following integer types follow the format:
    // 0, 1, 2, MAX - 2, MAX - 1, MAX
    const EXPECTED_VECTOR_U8: vector<u8> = vector<u8> [ 0, 1, 2, 253, 254, 255 ];
    const EXPECTED_VECTOR_U16: vector<u16> = vector<u16> [ 0, 1, 2, 65533, 65534, 65535 ];
    const EXPECTED_VECTOR_U32: vector<u32> = vector<u32> [ 0, 1, 2, 4294967293, 4294967294, 4294967295 ];
    const EXPECTED_VECTOR_U64: vector<u64> = vector<u64> [ 0, 1, 2, 18446744073709551613, 18446744073709551614, 18446744073709551615 ];
    const EXPECTED_VECTOR_U128: vector<u128> = vector<u128> [ 0, 1, 2, 340282366920938463463374607431768211453, 340282366920938463463374607431768211454, 340282366920938463463374607431768211455 ];
    const EXPECTED_VECTOR_U256: vector<u256> = vector<u256> [ 0, 1, 2, 115792089237316195423570985008687907853269984665640564039457584007913129639933, 115792089237316195423570985008687907853269984665640564039457584007913129639934, 115792089237316195423570985008687907853269984665640564039457584007913129639935 ];
    const EXPECTED_VECTOR_ADDRESS: vector<address> = vector<address> [ @0x0, @0xabc, @0xdef, @0x123, @0x456, @0x789 ];
    const EXPECTED_VECTOR_STRING: vector<vector<u8>> = vector<vector<u8>> [ b"expected_string", b"abc", b"def", b"123", b"456", b"789" ];

    struct SetupData has key {
        empty_object_1: Object<EmptyResource>,
        empty_object_2: Object<EmptyResource>,
        empty_object_3: Object<EmptyResource>,
    }

    struct EmptyResource has key { }

    fun init_module(deployer: &signer) {
        assert!(signer::address_of(deployer) == @transaction_arguments, 0);
        let objs = vector<Object<EmptyResource>> [ ];
        let i = 0;
        while(i < 3) {
            let constructor_ref = object::create_object(@transaction_arguments);
            let obj_signer = object::generate_signer(&constructor_ref);
            move_to(
                &obj_signer,
                EmptyResource {},
            );
            let obj = object::object_from_constructor_ref(&constructor_ref);
            vector::push_back(&mut objs, obj);
            i = i + 1;
        };
        vector::reverse(&mut objs);
        let setup_data = SetupData {
            empty_object_1: vector::pop_back(&mut objs),
            empty_object_2: vector::pop_back(&mut objs),
            empty_object_3: vector::pop_back(&mut objs),
        };

        move_to(
            deployer,
            setup_data,
        );
    }

    public entry fun type_tags<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20, T21, T22, T23, T24, T25, T26, T27, T28, T29>() {
        assert!(
            type_info::type_of<T0>() == type_info::type_of<bool>() &&
            type_info::type_of<T1>() == type_info::type_of<u8>() &&
            type_info::type_of<T2>() == type_info::type_of<u16>() &&
            type_info::type_of<T3>() == type_info::type_of<u32>() &&
            type_info::type_of<T4>() == type_info::type_of<u64>() &&
            type_info::type_of<T5>() == type_info::type_of<u128>() &&
            type_info::type_of<T6>() == type_info::type_of<u256>() &&
            type_info::type_of<T7>() == type_info::type_of<address>() &&
            type_info::type_of<T8>() == type_info::type_of<String>() &&
            type_info::type_of<T9>() == type_info::type_of<Object<EmptyResource>>() &&
            type_info::type_of<T10>() == type_info::type_of<vector<bool>>() &&
            type_info::type_of<T11>() == type_info::type_of<vector<u8>>() &&
            type_info::type_of<T12>() == type_info::type_of<vector<u16>>() &&
            type_info::type_of<T13>() == type_info::type_of<vector<u32>>() &&
            type_info::type_of<T14>() == type_info::type_of<vector<u64>>() &&
            type_info::type_of<T15>() == type_info::type_of<vector<u128>>() &&
            type_info::type_of<T16>() == type_info::type_of<vector<u256>>() &&
            type_info::type_of<T17>() == type_info::type_of<vector<address>>() &&   
            type_info::type_of<T18>() == type_info::type_of<vector<String>>() &&
            type_info::type_of<T19>() == type_info::type_of<vector<Object<EmptyResource>>>() &&
            type_info::type_of<T20>() == type_info::type_of<Option<bool>>() &&
            type_info::type_of<T21>() == type_info::type_of<Option<u8>>() &&
            type_info::type_of<T22>() == type_info::type_of<Option<u16>>() &&
            type_info::type_of<T23>() == type_info::type_of<Option<u32>>() &&
            type_info::type_of<T24>() == type_info::type_of<Option<u64>>() &&
            type_info::type_of<T25>() == type_info::type_of<Option<u128>>() &&
            type_info::type_of<T26>() == type_info::type_of<Option<u256>>() &&
            type_info::type_of<T27>() == type_info::type_of<Option<address>>() &&
            type_info::type_of<T28>() == type_info::type_of<Option<String>>() &&
            type_info::type_of<T29>() == type_info::type_of<Option<Object<EmptyResource>>>(),
            0
        );
    }

    public entry fun public_arguments(
        arg_bool: bool,
        arg_u8: u8,
        arg_u16: u16,
        arg_u32: u32,
        arg_u64: u64,
        arg_u128: u128,
        arg_u256: u256,
        arg_address: address,
        arg_string: String,
        arg_object: Object<EmptyResource>,
        vector_empty: vector<u8>,
        vector_bool: vector<bool>,
        vector_u8: vector<u8>,
        vector_u16: vector<u16>,
        vector_u32: vector<u32>,
        vector_u64: vector<u64>,
        vector_u128: vector<u128>,
        vector_u256: vector<u256>,
        vector_address: vector<address>,
        vector_string: vector<String>,
        vector_object: vector<Object<EmptyResource>>,
        option_empty: Option<u8>,
        option_bool: Option<bool>,
        option_u8: Option<u8>,
        option_u16: Option<u16>,
        option_u32: Option<u32>,
        option_u64: Option<u64>,
        option_u128: Option<u128>,
        option_u256: Option<u256>,
        option_address: Option<address>,
        option_string: Option<String>,
        option_object: Option<Object<EmptyResource>>,
        // deeply_nested_1: vector<Option<vector<Option<vector<String>>>>>, // TODO
        // deeply_nested_2: vector<Option<vector<vector<vector<Option<u256>>>>>>, // TODO
        // deeply_nested_3: vector<Option<vector<vector<vector<Option<Object<EmptyResource>>>>>>>, // TODO
    ) acquires SetupData {
        assert!(arg_bool == EXPECTED_BOOL, 0);
        assert!(arg_u8 == EXPECTED_U8, 1);
        assert!(arg_u16 == EXPECTED_U16, 2);
        assert!(arg_u32 == EXPECTED_U32, 3);
        assert!(arg_u64 == EXPECTED_U64, 4);
        assert!(arg_u128 == EXPECTED_U128, 5);
        assert!(arg_u256 == EXPECTED_U256, 6);
        assert!(arg_address == EXPECTED_ADDRESS, 7);
        assert!(arg_string == string::utf8(EXPECTED_STRING), 8);
        assert!(arg_object == get_setup_data().empty_object_1, 9);
        assert_vectors_equal(vector_empty, vector<u8>[], 10);
        assert_vectors_equal(vector_bool, EXPECTED_VECTOR_BOOL, 11);
        assert_vectors_equal(vector_u8, EXPECTED_VECTOR_U8, 12);
        assert_vectors_equal(vector_u16, EXPECTED_VECTOR_U16, 13);
        assert_vectors_equal(vector_u32, EXPECTED_VECTOR_U32, 14);
        assert_vectors_equal(vector_u64, EXPECTED_VECTOR_U64, 15);
        assert_vectors_equal(vector_u128, EXPECTED_VECTOR_U128, 16);
        assert_vectors_equal(vector_u256, EXPECTED_VECTOR_U256, 17);
        assert_vectors_equal(vector_address, EXPECTED_VECTOR_ADDRESS, 18);
        assert_vectors_equal(vector_string, get_expected_vector_string(), 19);
        assert_vectors_equal(vector_object, get_test_objects_vector(), 20);
        assert_options_equal(option_empty, option::none<u8>(), 21);
        assert_options_equal(option_bool, option::some(EXPECTED_BOOL), 22);
        assert_options_equal(option_u8, option::some(EXPECTED_U8),23);
        assert_options_equal(option_u16, option::some(EXPECTED_U16), 24);
        assert_options_equal(option_u32, option::some(EXPECTED_U32),25);
        assert_options_equal(option_u64, option::some(EXPECTED_U64),26);
        assert_options_equal(option_u128, option::some(EXPECTED_U128), 27);
        assert_options_equal(option_u256, option::some(EXPECTED_U256), 28);
        assert_options_equal(option_address, option::some(EXPECTED_ADDRESS), 29);
        assert_options_equal(option_string, option::some(string::utf8(EXPECTED_STRING)), 30);
        let obj = get_setup_data().empty_object_1;
        assert_options_equal(option_object, option::some(obj), 31);
    }

    // Can't be called from a script payload
    entry fun private_arguments(
        arg_bool: bool,
        arg_u8: u8,
        arg_u16: u16,
        arg_u32: u32,
        arg_u64: u64,
        arg_u128: u128,
        arg_u256: u256,
        arg_address: address,
        arg_string: String,
        arg_object: Object<EmptyResource>,
        vector_empty: vector<u8>,
        vector_bool: vector<bool>,
        vector_u8: vector<u8>,
        vector_u16: vector<u16>,
        vector_u32: vector<u32>,
        vector_u64: vector<u64>,
        vector_u128: vector<u128>,
        vector_u256: vector<u256>,
        vector_address: vector<address>,
        vector_string: vector<String>,
        vector_object: vector<Object<EmptyResource>>,
        option_empty: Option<u8>,
        option_bool: Option<bool>,
        option_u8: Option<u8>,
        option_u16: Option<u16>,
        option_u32: Option<u32>,
        option_u64: Option<u64>,
        option_u128: Option<u128>,
        option_u256: Option<u256>,
        option_address: Option<address>,
        option_string: Option<String>,
        option_object: Option<Object<EmptyResource>>,
    ) acquires SetupData {
        public_arguments(
            arg_bool, arg_u8, arg_u16, arg_u32, arg_u64, arg_u128, arg_u256, arg_address, arg_string, arg_object,
            vector_empty, vector_bool, vector_u8, vector_u16, vector_u32, vector_u64, vector_u128, vector_u256, vector_address, vector_string, vector_object,
            option_empty, option_bool, option_u8, option_u16, option_u32, option_u64, option_u128, option_u256, option_address, option_string, option_object,
        );
    }

    public entry fun public_arguments_one_signer(
        account_1: &signer,
        signer_address: address,
        arg_bool: bool,
        arg_u8: u8,
        arg_u16: u16,
        arg_u32: u32,
        arg_u64: u64,
        arg_u128: u128,
        arg_u256: u256,
        arg_address: address,
        arg_string: String,
        arg_object: Object<EmptyResource>,
        vector_empty: vector<u8>,
        vector_bool: vector<bool>,
        vector_u8: vector<u8>,
        vector_u16: vector<u16>,
        vector_u32: vector<u32>,
        vector_u64: vector<u64>,
        vector_u128: vector<u128>,
        vector_u256: vector<u256>,
        vector_address: vector<address>,
        vector_string: vector<String>,
        vector_object: vector<Object<EmptyResource>>,
        option_empty: Option<u8>,
        option_bool: Option<bool>,
        option_u8: Option<u8>,
        option_u16: Option<u16>,
        option_u32: Option<u32>,
        option_u64: Option<u64>,
        option_u128: Option<u128>,
        option_u256: Option<u256>,
        option_address: Option<address>,
        option_string: Option<String>,
        option_object: Option<Object<EmptyResource>>,
    ) acquires SetupData {
        assert!(signer::address_of(account_1) == signer_address, 0);

        public_arguments(
            arg_bool, arg_u8, arg_u16, arg_u32, arg_u64, arg_u128, arg_u256, arg_address, arg_string, arg_object,
            vector_empty, vector_bool, vector_u8, vector_u16, vector_u32, vector_u64, vector_u128, vector_u256, vector_address, vector_string, vector_object,
            option_empty, option_bool, option_u8, option_u16, option_u32, option_u64, option_u128, option_u256, option_address, option_string, option_object,
        );
    }

    public entry fun public_arguments_multiple_signers(
        account_1: &signer,
        account_2: &signer,
        account_3: &signer,
        account_4: &signer,
        account_5: &signer,
        signer_addresses: vector<address>,
        arg_bool: bool,
        arg_u8: u8,
        arg_u16: u16,
        arg_u32: u32,
        arg_u64: u64,
        arg_u128: u128,
        arg_u256: u256,
        arg_address: address,
        arg_string: String,
        arg_object: Object<EmptyResource>,
        vector_empty: vector<u8>,
        vector_bool: vector<bool>,
        vector_u8: vector<u8>,
        vector_u16: vector<u16>,
        vector_u32: vector<u32>,
        vector_u64: vector<u64>,
        vector_u128: vector<u128>,
        vector_u256: vector<u256>,
        vector_address: vector<address>,
        vector_string: vector<String>,
        vector_object: vector<Object<EmptyResource>>,
        option_empty: Option<u8>,
        option_bool: Option<bool>,
        option_u8: Option<u8>,
        option_u16: Option<u16>,
        option_u32: Option<u32>,
        option_u64: Option<u64>,
        option_u128: Option<u128>,
        option_u256: Option<u256>,
        option_address: Option<address>,
        option_string: Option<String>,
        option_object: Option<Object<EmptyResource>>,
    ) acquires SetupData {
        let signer_addresses_passed_in = vector<address> [
            signer::address_of(account_1),
            signer::address_of(account_2),
            signer::address_of(account_3),
            signer::address_of(account_4),
            signer::address_of(account_5),
        ];
        assert_vectors_equal(signer_addresses, signer_addresses_passed_in, 0);

        public_arguments(
            arg_bool, arg_u8, arg_u16, arg_u32, arg_u64, arg_u128, arg_u256, arg_address, arg_string, arg_object,
            vector_empty, vector_bool, vector_u8, vector_u16, vector_u32, vector_u64, vector_u128, vector_u256, vector_address, vector_string, vector_object,
            option_empty, option_bool, option_u8, option_u16, option_u32, option_u64, option_u128, option_u256, option_address, option_string, option_object,
        );
    }

    inline fun assert_vectors_equal<T: drop>(vec_1: vector<T>, vec_2: vector<T>, arg_index: u64) {
        assert!(vector::length<T>(&vec_1) == vector::length<T>(&vec_2), error::invalid_state(INCORRECT_VECTOR_LENGTH + arg_index));
        vector::zip<T, T>(vec_1, vec_2, |a, b| {
            assert!(a == b, error::invalid_state(arg_index));
        });
    }

    inline fun assert_options_equal<T>(option_1: Option<T>, option_2: Option<T>, arg_index: u64) {
        if (option::is_none<T>(&option_1)) {
            assert!(option::is_none<T>(&option_2), error::invalid_state(OPTION_EQUALITY_ERROR_0 + arg_index));
        } else {
            assert!(option::is_some<T>(&option_2), error::invalid_state(OPTION_EQUALITY_ERROR_1 + arg_index));
            let element = option::borrow<T>(&option_1);
            assert!(option::contains(&option_2, element), error::invalid_state(OPTION_EQUALITY_ERROR_2 + arg_index));
        }
    }

    #[view]
    public fun view_all_arguments(
        arg_bool: bool,
        arg_u8: u8,
        arg_u16: u16,
        arg_u32: u32,
        arg_u64: u64,
        arg_u128: u128,
        arg_u256: u256,
        arg_address: address,
        arg_string: String,
        arg_object: Object<EmptyResource>,
        vector_empty: vector<u8>,
        vector_bool: vector<bool>,
        vector_u8: vector<u8>,
        vector_u16: vector<u16>,
        vector_u32: vector<u32>,
        vector_u64: vector<u64>,
        vector_u128: vector<u128>,
        vector_u256: vector<u256>,
        vector_address: vector<address>,
        vector_string: vector<String>,
        vector_object: vector<Object<EmptyResource>>,
        option_empty: Option<u8>,
        option_bool: Option<bool>,
        option_u8: Option<u8>,
        option_u16: Option<u16>,
        option_u32: Option<u32>,
        option_u64: Option<u64>,
        option_u128: Option<u128>,
        option_u256: Option<u256>,
        option_address: Option<address>,
        option_string: Option<String>,
        option_object: Option<Object<EmptyResource>>,
    ): (
        bool,
        u8,
        u16,
        u32,
        u64,
        u128,
        u256,
        address,
        String,
        Object<EmptyResource>,
        vector<u8>,
        vector<bool>,
        vector<u8>,
        vector<u16>,
        vector<u32>,
        vector<u64>,
        vector<u128>,
        vector<u256>,
        vector<address>,
        vector<String>,
        vector<Object<EmptyResource>>,
        Option<u8>,
        Option<bool>,
        Option<u8>,
        Option<u16>,
        Option<u32>,
        Option<u64>,
        Option<u128>,
        Option<u256>,
        Option<address>,
        Option<String>,
        Option<Object<EmptyResource>>,
    ) {
        (
            arg_bool,
            arg_u8,
            arg_u16,
            arg_u32,
            arg_u64,
            arg_u128,
            arg_u256,
            arg_address,
            arg_string,
            arg_object,
            vector_empty,
            vector_bool,
            vector_u8,
            vector_u16,
            vector_u32,
            vector_u64,
            vector_u128,
            vector_u256,
            vector_address,
            vector_string,
            vector_object,
            option_empty,
            option_bool,
            option_u8,
            option_u16,
            option_u32,
            option_u64,
            option_u128,
            option_u256,
            option_address,
            option_string,
            option_object,
        )
    }

    #[view]
    public fun get_expected_vector_string(): vector<String> {
        vector::map(EXPECTED_VECTOR_STRING, |s| {
            string::utf8(s)
        })
    }

    inline fun get_setup_data(): &SetupData {
        borrow_global<SetupData>(@transaction_arguments)
    }

    #[view]
    public fun get_test_objects(): (Object<EmptyResource>, Object<EmptyResource>, Object<EmptyResource>) acquires SetupData {
        let setup_data = get_setup_data();
        (
            setup_data.empty_object_1,
            setup_data.empty_object_2,
            setup_data.empty_object_3,
        )
    }

    inline fun get_test_objects_vector(): vector<Object<EmptyResource>> {
        let (object_1, object_2, object_3) = get_test_objects();
        vector<Object<EmptyResource>> [ object_1, object_2, object_3 ]
    }

    #[view]
    public fun get_test_object_addresses(): (address, address, address) acquires SetupData {
        let (object_1, object_2, object_3) = get_test_objects();
        (
            object::object_address<EmptyResource>(&object_1),
            object::object_address<EmptyResource>(&object_2),
            object::object_address<EmptyResource>(&object_3),
        )
    }

    #[test(deployer=@transaction_arguments, signer_2=@0xa, signer_3=@0xb, signer_4=@0xc, signer_5=@0xd, core=@0x1)]
    fun test_all_functions(
        deployer: &signer,
        signer_2: &signer,
        signer_3: &signer,
        signer_4: &signer,
        signer_5: &signer,
        core: &signer,
    ) acquires SetupData {
        use std::features;
        let feature = features::get_auids();
        features::change_feature_flags(core, vector[feature], vector[]);

        let deployer_address = signer::address_of(deployer);
        let signer_2_address = signer::address_of(signer_2);
        let signer_3_address = signer::address_of(signer_3);
        let signer_4_address = signer::address_of(signer_4);
        let signer_5_address = signer::address_of(signer_5);

        init_module(deployer);

        public_arguments(
            EXPECTED_BOOL,
            EXPECTED_U8,
            EXPECTED_U16,
            EXPECTED_U32,
            EXPECTED_U64,
            EXPECTED_U128,
            EXPECTED_U256,
            EXPECTED_ADDRESS,
            string::utf8(EXPECTED_STRING),
            get_setup_data().empty_object_1,
            vector<u8>[],
            EXPECTED_VECTOR_BOOL,
            EXPECTED_VECTOR_U8,
            EXPECTED_VECTOR_U16,
            EXPECTED_VECTOR_U32,
            EXPECTED_VECTOR_U64,
            EXPECTED_VECTOR_U128,
            EXPECTED_VECTOR_U256,
            EXPECTED_VECTOR_ADDRESS,
            get_expected_vector_string(),
            get_test_objects_vector(),
            option::none<u8>(),
            option::some(EXPECTED_BOOL),
            option::some(EXPECTED_U8),
            option::some(EXPECTED_U16),
            option::some(EXPECTED_U32),
            option::some(EXPECTED_U64),
            option::some(EXPECTED_U128),
            option::some(EXPECTED_U256),
            option::some(EXPECTED_ADDRESS),
            option::some(string::utf8(EXPECTED_STRING)),
            option::some(get_setup_data().empty_object_1),
        );

        private_arguments(
            EXPECTED_BOOL,
            EXPECTED_U8,
            EXPECTED_U16,
            EXPECTED_U32,
            EXPECTED_U64,
            EXPECTED_U128,
            EXPECTED_U256,
            EXPECTED_ADDRESS,
            string::utf8(EXPECTED_STRING),
            get_setup_data().empty_object_1,
            vector<u8>[],
            EXPECTED_VECTOR_BOOL,
            EXPECTED_VECTOR_U8,
            EXPECTED_VECTOR_U16,
            EXPECTED_VECTOR_U32,
            EXPECTED_VECTOR_U64,
            EXPECTED_VECTOR_U128,
            EXPECTED_VECTOR_U256,
            EXPECTED_VECTOR_ADDRESS,
            get_expected_vector_string(),
            get_test_objects_vector(),
            option::none<u8>(),
            option::some(EXPECTED_BOOL),
            option::some(EXPECTED_U8),
            option::some(EXPECTED_U16),
            option::some(EXPECTED_U32),
            option::some(EXPECTED_U64),
            option::some(EXPECTED_U128),
            option::some(EXPECTED_U256),
            option::some(EXPECTED_ADDRESS),
            option::some(string::utf8(EXPECTED_STRING)),
            option::some(get_setup_data().empty_object_1),
        );

        public_arguments_one_signer(
            deployer,
            deployer_address,
            EXPECTED_BOOL,
            EXPECTED_U8,
            EXPECTED_U16,
            EXPECTED_U32,
            EXPECTED_U64,
            EXPECTED_U128,
            EXPECTED_U256,
            EXPECTED_ADDRESS,
            string::utf8(EXPECTED_STRING),
            get_setup_data().empty_object_1,
            vector<u8>[],
            EXPECTED_VECTOR_BOOL,
            EXPECTED_VECTOR_U8,
            EXPECTED_VECTOR_U16,
            EXPECTED_VECTOR_U32,
            EXPECTED_VECTOR_U64,
            EXPECTED_VECTOR_U128,
            EXPECTED_VECTOR_U256,
            EXPECTED_VECTOR_ADDRESS,
            get_expected_vector_string(),
            get_test_objects_vector(),
            option::none<u8>(),
            option::some(EXPECTED_BOOL),
            option::some(EXPECTED_U8),
            option::some(EXPECTED_U16),
            option::some(EXPECTED_U32),
            option::some(EXPECTED_U64),
            option::some(EXPECTED_U128),
            option::some(EXPECTED_U256),
            option::some(EXPECTED_ADDRESS),
            option::some(string::utf8(EXPECTED_STRING)),
            option::some(get_setup_data().empty_object_1),
        );
        
        public_arguments_multiple_signers(
            deployer,
            signer_2,
            signer_3,
            signer_4,
            signer_5,
            vector<address> [ deployer_address, signer_2_address, signer_3_address, signer_4_address, signer_5_address, ],
            EXPECTED_BOOL,
            EXPECTED_U8,
            EXPECTED_U16,
            EXPECTED_U32,
            EXPECTED_U64,
            EXPECTED_U128,
            EXPECTED_U256,
            EXPECTED_ADDRESS,
            string::utf8(EXPECTED_STRING),
            get_setup_data().empty_object_1,
            vector<u8>[],
            EXPECTED_VECTOR_BOOL,
            EXPECTED_VECTOR_U8,
            EXPECTED_VECTOR_U16,
            EXPECTED_VECTOR_U32,
            EXPECTED_VECTOR_U64,
            EXPECTED_VECTOR_U128,
            EXPECTED_VECTOR_U256,
            EXPECTED_VECTOR_ADDRESS,
            get_expected_vector_string(),
            get_test_objects_vector(),
            option::none<u8>(),
            option::some(EXPECTED_BOOL),
            option::some(EXPECTED_U8),
            option::some(EXPECTED_U16),
            option::some(EXPECTED_U32),
            option::some(EXPECTED_U64),
            option::some(EXPECTED_U128),
            option::some(EXPECTED_U256),
            option::some(EXPECTED_ADDRESS),
            option::some(string::utf8(EXPECTED_STRING)),
            option::some(get_setup_data().empty_object_1),
        );
    }

}
