"""contract.cairo test file."""
import os

import pytest
from starkware.starknet.testing.starknet import Starknet

# The path to the contract source code.
CONTRACT_FILE = os.path.join("contracts", "ERC2981.cairo")


# The testing library uses python's asyncio. So the following
# decorator and the ``async`` keyword are needed.
@pytest.mark.asyncio
async def test_supportsInterface():
    """Test supportsInterface method."""
    # Create a new Starknet class that simulates the StarkNet
    # system.
    starknet = await Starknet.empty()

    # Deploy the contract.
    contract = await starknet.deploy(
        source=CONTRACT_FILE,
    )

    # bytes4(keccak256("royaltyInfo(uint256,uint256)")) == 0x2a55205a
    # bytes4 private constant _INTERFACE_ID_ERC2981 = 0x2a55205a;
    # Invoke supportsInterface(0x2a55205a).
    res = await contract.supportsInterface(interface_id=0x2a55205a).call()

    assert res.result == (1,)

@pytest.mark.asyncio
async def test_setTokenRoyalty():
    """Test setTokenRoyalty method."""
    # Create a new Starknet class that simulates the StarkNet
    # system.
    starknet = await Starknet.empty()

    # Deploy the contract.
    contract = await starknet.deploy(
        source=CONTRACT_FILE,
    )
    

    # set token 1 royalties
    tokenOwner=123456789
    await contract.setTokenRoyalty(_tokenId=1, _recipient=tokenOwner, _amount=2).invoke()
    res = await contract.getRoyaltyInfo(_tokenId=(1,0), _salePrice=(1000,0)).call()

    assert res.result == (tokenOwner, (20,0),)
