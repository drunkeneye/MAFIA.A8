import hashlib
import struct

class InsnSequence:
    def __init__(self, insns=None):
        self.insns = insns if insns else []
        self.hash = self.calculate_hash()

    def calculate_hash(self):
        md5 = hashlib.md5()
        for insn in self.insns:
            md5.update(insn.packed)
        return int.from_bytes(md5.digest(), byteorder='big')

    def __eq__(self, other):
        if self.hash != other.hash or len(self.insns) != len(other.insns):
            return False
        for insn1, insn2 in zip(self.insns, other.insns):
            if insn1.packed != insn2.packed:
                return False
        return True



class HashBlock:
    N = 63

    def __init__(self):
        self.nodes = [None] * self.N
        self.next = None


class HashChain:
    def __init__(self):
        self.first = None
        self.offset = 0


class InsnSequenceCache:
    def __init__(self):
        self.hash_table = [HashChain() for _ in range(1024)]

    def clear(self):
        self.hash_table = [HashChain() for _ in range(1024)]

    def insert(self, key, alloc):
        hash_value = key.hash & 1023
        hc = self.hash_table[hash_value]
        hb = hc.first
        hbidx = hc.offset
        hbidx2 = hbidx

        for hb2 in [hb] + [hb2.next for hb2 in hb]:
            for i in range(hbidx2 - 1, -1, -1):
                if key == hb2.nodes[i]:
                    return hb2.nodes[i]

            hbidx2 = HashBlock.N

        if not hb or hbidx >= HashBlock.N:
            hb2 = HashBlock()
            hb2.next = hb
            hc.first = hb2
            hb = hb2
            hbidx = 0

        hc.offset = hbidx + 1

        ri = None
        if key.insns:
            ri = [SRasterInstruction() for _ in range(key.insn_count)]
            for idx, insn in enumerate(key.insns):
                ri[idx].instruction = insn.instruction
                ri[idx].target = insn.target
                ri[idx].value = insn.value

        node = InsnSequence(ri)
        node.hash = key.hash
        node.insns = ri
        node.insn_count = key.insn_count

        hb.nodes[hbidx] = node
        return node

