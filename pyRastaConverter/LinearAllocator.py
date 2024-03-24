class LinearAllocator:
    BLOCK_SIZE = 8388608

    def __init__(self):
        self.chunk_list = None
        self.alloc_left = 0
        self.alloc_total = 0

    def clear(self):
        while self.chunk_list:
            next_chunk = self.chunk_list.next
            del self.chunk_list
            self.chunk_list = next_chunk
        self.alloc_left = 0
        self.alloc_total = 0

    def size(self):
        return self.alloc_total

    def allocate(self, n):
        n = (n + 7) & ~7

        if self.alloc_left < n:
            to_alloc = self.BLOCK_SIZE - 64 - self.chunk_node_size()

            if to_alloc < n:
                to_alloc = n

            new_node = ChunkNode()
            new_node.next = self.chunk_list
            self.chunk_list = new_node
            self.alloc_ptr = new_node + 1
            self.alloc_left = to_alloc
            self.alloc_total += to_alloc + self.chunk_node_size()

        p = self.alloc_ptr
        self.alloc_ptr += n
        self.alloc_left -= n
        return p

    def chunk_node_size(self):
        return 8 + len(self.chunk_list)

    def allocate_template(self, cls):
        return cls(self.allocate(len(cls())))


class ChunkNode:
    def __init__(self):
        self.next = None
        self.align_pad = None
