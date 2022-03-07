%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

from starkware.cairo.common.uint256 import Uint256, uint256_mul, uint256_unsigned_div_rem

from contracts.openzeppelin.introspection.ERC165 import (
    ERC165_register_interface, ERC165_supports_interface, ERC165_supported_interfaces)

func ERC2981_initializer{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    ERC165_register_interface(0x2a55205a)
    return ()
end

struct RoyaltyInfo:
    member recipient : felt
    member amount : Uint256
end

@storage_var
func ERC2981_token_royalties_(token_id : Uint256) -> (royalty_info : RoyaltyInfo):
end

func ERC2981_supports_interface{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        interface_id : felt) -> (is_supported : felt):
    let (isSupported : felt) = ERC165_supports_interface(interface_id)
    return (isSupported)
end

func ERC2981_set_royalty_internal{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        _tokenId : Uint256, _recipient : felt, _amount : Uint256):
    let royalty : RoyaltyInfo = RoyaltyInfo(recipient=_recipient, amount=_amount)
    ERC2981_token_royalties_.write(_tokenId, royalty)
    return ()
end

func ERC2981_royalty_info{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        _tokenId : Uint256, _salePrice : Uint256) -> (receiver : felt, royaltyAmount : Uint256):
    alloc_locals
    let (local royalty_info : RoyaltyInfo) = ERC2981_token_royalties_.read(_tokenId)
    let receiver : felt = royalty_info.recipient
    let amount = royalty_info.amount
    let (product : Uint256, _) = uint256_mul(_salePrice, amount)
    let (royaltyAmount : Uint256, rem : Uint256) = uint256_unsigned_div_rem(
        product, Uint256(100, 0))
    return (receiver=receiver, royaltyAmount=royaltyAmount)
end
