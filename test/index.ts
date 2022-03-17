import { ethers } from 'hardhat'
import { getGasUsage } from './utils'
import type { Token } from '../typechain'

describe('Tests', function () {
  describe('Multicall gas savings', () => {
    let token: Token
    let user1, user2, user3, user4, user5

    before(async () => {
      ;[user1, user2, user3, user4, user5] = await ethers.getSigners()
      const TokenFactory = await ethers.getContractFactory('Token')
      token = await TokenFactory.deploy()
      await token.mint(user1.address, 2000)
    })

    it('gas usage in 2 sends', async () => {
      let totalGasCost = 0
      totalGasCost += await getGasUsage(await token.transfer(user2.address, 200))
      totalGasCost += await getGasUsage(await token.transfer(user3.address, 200))
      console.log(`separate tx gas cost: ${totalGasCost}`)
    })

    it('multicalled gas cost', async () => {
      const transfers = [
        token.interface.encodeFunctionData('transfer', [user4.address, 200]),
        token.interface.encodeFunctionData('transfer', [user5.address, 200])
      ]
      const totalGasCost = await getGasUsage(await token.multicall(transfers))
      console.log(`multicall gas cost: ${totalGasCost}`)
    })
  })
})
