from PIL import Image

def invert(img):
	rgb_img = img.convert('RGB')
	width, height = rgb_img.size
	
	img2 = Image.new('RGB', (width, height))
	for y in range(height):
		for x in range(width):
			r, g, b = rgb_img.getpixel((x, y))
			r = 255 - r
			g = 255 - g
			b = 255 - b
			# print(f'(x:{x},y:{y} = ({r},{g},{}))')
			img2.putpixel((x, y), (r, g, b))

	return img2

# via https://qiita.com/zaburo/items/0b9db87d0a52191b164b
def blur(img):
	rgb_img = img.convert('RGB')
	width, height = rgb_img.size
	
	img2 = Image.new('RGB', (width, height))
	for y in range(height):
		for x in range(width):
			r0, g0, b0 = rgb_img.getpixel((x, y))
			r1 = r2 = r3 = r4 = r5 = r6 = r7 = r8 = r0
			g1 = g2 = g3 = g4 = g5 = g6 = g7 = g8 = g0
			b1 = b2 = b3 = b4 = b5 = b6 = b7 = b8 = b0
			
			if x - 1 > 0 and y + 1 < height:
				r1, g1, b1 = rgb_img.getpixel((x - 1, y + 1))
			if y + 1 < height:
				r2, g2, b2 = rgb_img.getpixel((x, y + 1))
			if x + 1 < width and y + 1 < height:
				r3, g3, b3 = rgb_img.getpixel((x + 1, y + 1))
			if x - 1 > 0:
				r4, g4, b4 = rgb_img.getpixel((x - 1, y))
			if x + 1 < width:
				r5, g5, b5 = rgb_img.getpixel((x + 1, y))
			if x - 1 > 0 and y - 1 > 0:
				r6, g6, b6 = rgb_img.getpixel((x - 1, y - 1))
			if y - 1 > 0:
				r7, g7, b7 = rgb_img.getpixel((x, y - 1))
			if x + 1 < width and y - 1 > 0:
				r8, g8, b8 = rgb_img.getpixel((x + 1, y - 1))
			
			r = int((r0 + r1 + r2 + r3 + r4 + r5 + r6 + r7 + r8) / 9)
			g = int((g0 + g1 + g2 + g3 + g4 + g5 + g6 + g7 + g8) / 9)
			b = int((b0 + b1 + b2 + b3 + b4 + b5 + b6 + b7 + b8) / 9)
			img2.putpixel((x, y), (r, g, b))
	
	return img2

def main():
	img = Image.open('test:Lenna')
	# img.show()
	
	# inverted_img = invert(img)
	# inverted_img.show()
	
	blured_img = blur(img)
	blured_img.show()

if __name__ == '__main__':
	main()
