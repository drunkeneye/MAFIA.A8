from enum import Enum
import struct


sprite_screen_color_cycle_start = 48
sprite_size = 32
free_cycles = 53
CYCLES_MAX = 114
screen_cycles = [None] * CYCLES_MAX


class SRasterInstruction(Enum):
    E_RASTER_LDA = 0
    E_RASTER_LDX = 1
    E_RASTER_LDY = 2
    E_RASTER_NOP = 3
    E_RASTER_STA = 4
    E_RASTER_STX = 5
    E_RASTER_STY = 6
    E_RASTER_MAX = 7


class ETarget(Enum):
    E_COLOR0 = 0
    E_COLOR1 = 1
    E_COLOR2 = 2
    E_COLBAK = 3
    E_COLPM0 = 4
    E_COLPM1 = 5
    E_COLPM2 = 6
    E_COLPM3 = 7
    E_HPOSP0 = 8
    E_HPOSP1 = 9
    E_HPOSP2 = 10
    E_HPOSP3 = 11
    E_TARGET_MAX = 12


class EMutationType(Enum):
    E_MUTATION_PUSH_BACK_TO_PREV = 0
    E_MUTATION_COPY_LINE_TO_NEXT_ONE = 1
    E_MUTATION_SWAP_LINE_WITH_PREV_ONE = 2
    E_MUTATION_ADD_INSTRUCTION = 3
    E_MUTATION_REMOVE_INSTRUCTION = 4
    E_MUTATION_SWAP_INSTRUCTION = 5
    E_MUTATION_CHANGE_TARGET = 6
    E_MUTATION_CHANGE_VALUE = 7
    E_MUTATION_CHANGE_VALUE_TO_COLOR = 8
    E_MUTATION_MAX = 9


class ScreenCycle:
    def __init__(self, offset, length):
        self.offset = offset
        self.length = length


class ScreenLine:
    def __init__(self):
        self.pixels = []

    def resize(self, i):
        self.pixels = [None] * i

    def __getitem__(self, i):
        return self.pixels[i]

    def __setitem__(self, i, value):
        self.pixels[i] = value

    def size(self):
        return len(self.pixels)


class SRasterInstruction:
    def __init__(self, instruction=0, target=0, value=0):
        self.loose = struct.pack('<HBB', instruction, target, value)

    @property
    def packed(self):
        return self.loose

    def __eq__(self, other):
        return self.packed == other.packed

    def hash(self):
        return hash(self.loose)


class RasterLine:
    def __init__(self):
        self.instructions = []
        self.cycles = 0
        self.hash = 0
        self.cache_key = None

    def rehash(self):
        h = 0
        for insn in self.instructions:
            h += insn.hash()
            h = (h >> 27) + (h << 5)
        self.hash = h

    def recache_insns(self, cache, alloc):
        is_ = InsnSequence()
        is_.hash = self.hash
        is_.insns = self.instructions
        is_.insn_count = len(self.instructions)
        self.cache_key = cache.insert(is_, alloc)

    def swap(self, other):
        self.instructions, other.instructions = other.instructions, self.instructions
        self.cycles, other.cycles = other.cycles, self.cycles
        self.hash, other.hash = other.hash, self.hash
        self.cache_key, other.cache_key = other.cache_key, self.cache_key


class RasterPicture:
    def __init__(self, height=0):
        self.mem_regs_init = [0] * ETarget.E_TARGET_MAX.value
        self.raster_lines = [RasterLine() for _ in range(height)]

    def recache_insns(self, cache, alloc):
        for line in self.raster_lines:
            line.recache_insns(cache, alloc)

    def uncache_insns(self):
        for line in self.raster_lines:
            line.cache_key = None


///

def get_instruction_cycles(instr):
    if instr.loose.instruction in [SRasterInstruction.E_RASTER_NOP.value,
                                    SRasterInstruction.E_RASTER_LDA.value,
                                    SRasterInstruction.E_RASTER_LDX.value,
                                    SRasterInstruction.E_RASTER_LDY.value]:
        return 2
    return 4


class InsnSequence:
    def __init__(self):
        self.insns = []
        self.insn_count = 0
        self.hash = 0

    def __eq__(self, other):
        if self.hash != other.hash or len(self.insns) != len(other.insns):
            return False
        for insn1, insn2 in zip(self.insns, other.insns):
            if insn1.packed != insn2.packed:
                return False
        return True


# Example usage:
insn_sequence = InsnSequence()
insn_sequence.insns.append(SRasterInstruction(1, 2, 3))
insn_sequence.insns.append(SRasterInstruction(4, 5, 6))
