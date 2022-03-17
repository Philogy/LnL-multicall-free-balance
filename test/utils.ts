const getGasUsage = async (tx) => {
  const { gasUsed } = await tx.wait()
  return gasUsed.toNumber()
}

export { getGasUsage }
