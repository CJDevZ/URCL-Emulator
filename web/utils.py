from typing import Iterable, Iterator, TypeVar

T = TypeVar('T')

def iterate_with_last(iterable: Iterable[T]) -> Iterator[tuple[T, bool]]:
    iterator = iter(iterable)

    try:
        current = next(iterator)
    except StopIteration:
        return

    for nxt in iterator:
        yield current, False
        current = nxt

    yield current, True
