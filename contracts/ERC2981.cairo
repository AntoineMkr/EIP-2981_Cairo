%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

from starkware.cairo.common.uint256 import Uint256, uint256_mul, uint256_unsigned_div_rem

from contracts.openzeppelin.introspection.ERC165 import (
    ERC165_register_interface, ERC165_supports_interface, ERC165_supported_interfaces)

from contracts.ERC2981_base import (
    ERC2981_initializer, ERC2981_royalty_info, ERC2981_set_royalty_internal,
    ERC2981_supports_interface, ERC2981_token_royalties_, RoyaltyInfo)

@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    ERC2981_initializer()
    return ()
end

# there is a non-necessary step here a call of a call of a call of ERC165_supports_interface
# might update that later
@external
func supportsInterface{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        interface_id : felt) -> (is_supported : felt):
    let (isSupported : felt) = ERC2981_supports_interface(interface_id)
    return (isSupported)
end

# Should add onlyOwner modifier here
@external
func setTokenRoyalty{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        _tokenId : Uint256, _recipient : felt, _amount : Uint256):
    ERC2981_set_royalty_internal(_tokenId, _recipient, _amount)
    return ()
end

# You might want to customise the logic here
@external
func getRoyaltyInfo{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        _tokenId : Uint256, _salePrice : Uint256) -> (receiver : felt, royaltyAmount : Uint256):
    alloc_locals
    let (receiver : felt, royaltyAmount : Uint256) = ERC2981_royalty_info(_tokenId, _salePrice)
    return (receiver=receiver, royaltyAmount=royaltyAmount)
end
