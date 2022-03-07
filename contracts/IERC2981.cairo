%lang starknet

from starkware.cairo.common.uint256 import Uint256

@contract_interface
namespace IERC2981:
    func royaltyInfo(_tokenId : Uint256, _salePrice : Uint256) -> (
            receiver : felt, royaltyAmount : Uint256):
    end
end
