import hashlib
import struct

class SRasterInstruction:
    def __init__(self, instruction=0, target=0, value=0):
        self.instruction = instruction
        self.target = target
        self.value = value

    @property
    def packed(self):
        return struct.pack('<HBB', self.instruction, self.target, self.value)

