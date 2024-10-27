import asyncio
import sys
import ast
from starknet_py.net.full_node_client import FullNodeClient

async def verify_contract():
   try:
       with open('hydra/garaga/starknet/groth16_contract_generator/generator.py', 'r') as f:
           tree = ast.parse(f.read())
           for node in ast.walk(tree):
               if isinstance(node, ast.Assign) and len(node.targets) == 1:
                   if getattr(node.targets[0], 'id', None) == 'ECIP_OPS_CLASS_HASH':
                       class_hash = hex(node.value.value)
                       break
       print(f'Using class hash: {class_hash}')
   except Exception as e:
       print(f'Error parsing generator.py: {str(e)}', file=sys.stderr)
       sys.exit(1)

   print('\nVerifying on Sepolia...')
   sepolia = FullNodeClient('https://free-rpc.nethermind.io/sepolia-juno')
   try:
       sepolia_result = await sepolia.get_class_by_hash(class_hash)
       if not sepolia_result:
           print('Error: Contract not declared on Sepolia', file=sys.stderr)
           sys.exit(1)
       print('✓ Contract verified on Sepolia')
   except Exception as e:
       print(f'Error checking Sepolia: {str(e)}', file=sys.stderr)
       sys.exit(1)

   print('\nVerifying on Mainnet...')
   mainnet = FullNodeClient('https://free-rpc.nethermind.io/mainnet-juno')
   try:
       mainnet_result = await mainnet.get_class_by_hash(class_hash)
       if not mainnet_result:
           print('Error: Contract not declared on Mainnet', file=sys.stderr)
           sys.exit(1)
       print('✓ Contract verified on Mainnet')
   except Exception as e:
       print(f'Error checking Mainnet: {str(e)}', file=sys.stderr)
       sys.exit(1)

   print('\n✓ Contract verified on both networks')

if __name__ == "__main__":
   asyncio.run(verify_contract())
