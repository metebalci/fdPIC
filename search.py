import sys

def f(a, b, c):
    return (10 + a * (5 + b * (5 + (c * 5))))

x = int(sys.argv[1])
if x % 8 <> 0:
    print("ratio should be a multiple of 8")
else:
    print("searching for: %d" % (x,))
    x = x / 8
    for a in range(1, 255):
        for b in range(1, 255):
            for c in range(1, 255):
                if x == f(a, b, c):
                    print("%9d => a=%3d, b=%3d, c=%3d" % (x, a, b, c))
