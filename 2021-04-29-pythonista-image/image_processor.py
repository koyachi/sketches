from PIL import Image, ImageDraw
import math

BLACK, DARKGRAY, GRAY = ((0,0,0), (63,63,63), (127,127,127))
LIGHTGRAY, WHITE = ((191,191,191), (255,255,255))
BLUE, GREEN, RED = ((0,0,255), (0,255,0), (255,0,0))

class Point(object):
	def __init__(self, x, y):
		self.x, self.y = x, y
	
	@staticmethod
	def from_point(other):
		return Point(other.x, other.y)

class Rect(object):
	def __init__(self, x1, y1, x2, y2):
		minx, maxx = (x1, x2) if x1 < x2 else (x2, x1)
		miny, maxy = (y1, y2) if y1 < y2 else (y2, y1)
		self.min = Point(minx, miny)
		self.max = Point(maxx, maxy)
	
	@staticmethod
	def from_points(p1, p2):
		return Rect(p1.x, p1.y, p2.x, p2.y)
	
	def __str__(self):
		return 'Rect({:d}, {:d}, {:d}, {:d})'.format(
			self.min.x, self.min.y,
			self.max.x, self.max.y)
	
	width = property(lambda self: self.max.x - self.min.x)
	height = property(lambda self: self.max.y - self.min.y)

def gradient_color(minval, maxval, val, color_palette):
	max_index = len(color_palette) - 1
	delta = maxval - minval
	if delta == 0:
		delta = 1
	v = float(val - minval) / delta * max_index
	i1, i2 = int(v), min(int(v) + 1, max_index)
	(r1, g1, b1), (r2, g2, b2) = color_palette[i1], color_palette[i2]
	f = v - i1
	return int(r1 + f * (r2 - r1)), int(g1 + f * (g2 - g1)), int(b1 + f * b2 - b1)

def vert_gradient(draw, rect, color_func, color_palette):
	minval, maxval = 1, len(color_palette)
	delta = maxval - minval
	for y in range(rect.min.y, rect.max.y + 1):
		f = (y - rect.min.y) / float(rect.height)
		val = minval + f * delta
		color = color_func(minval, maxval, val, color_palette)
		draw.line([(rect.min.x, y), (rect.max.x, y)], fill=color)

def gradient_demo():
	#color_palette = [BLUE, GREEN, RED]
	color_palette = [BLACK, WHITE]
	# 白系から暗くなるとき黄色みがかるな
	# color_palette = [WHITE, BLACK]
	#color_palette = [LIGHTGRAY, BLACK]
	region = Rect(0, 0, 1024, 1024)
	imgx, imgy = region.max.x + 1, region.max.y + 1
	image = Image.new("RGB", (imgx, imgy), WHITE)
	draw = ImageDraw.Draw(image)
	vert_gradient(draw, region, gradient_color, color_palette)
	image.show()

def gradient_atkinson_image(width=190, height=100):
	# black潰れる
	#color_palette = [BLACK, WHITE]
	# GRAY=127
	#color_palette = [GRAY, WHITE]
	color_palette = [(90,90,90), (230,230,230)]
	# 1024はでかい
	#region = Rect(0, 0, 1024, 1024)
	#region = Rect(0, 0, 128, 128)
	#region = Rect(0, 0, 190, 190)
	region = Rect(0, 0, width, height)
	#region = Rect(0, 0, 256, 256)
	imgx, imgy = region.max.x + 1, region.max.y + 1
	image = Image.new("RGB", (imgx, imgy), WHITE)
	draw = ImageDraw.Draw(image)
	vert_gradient(draw, region, gradient_color, color_palette)
	atkinson_img = atkinson(image)
	#atkinson_img.show()
	return atkinson_img

# via https://stackoverflow.com/a/41980290
def draw_rectangle(draw, coordinate, color, width=1):
	for i in range(width):
		ii = i + 1
		rect_start = (coordinate[0][0] - ii, coordinate[0][1] - ii)
		rect_end = (coordinate[1][0] + ii, coordinate[1][1] + ii)
		draw.rectangle((rect_start, rect_end), outline = color)

# src_image: メイン画像
# output_width: 出力画像幅
# output_height: 出力画像高さ
# frame_thick: 	画像内の余白厚み(枠領域含む)
# border_thick: frame_thick内にしめる枠領域の厚み
# padding: メイン画像との余白
def frame_image(src_image, output_width, output_height, frame_thick, border_thick, padding):
	region = Rect(0, 0, output_width, output_height)
	imgx, imgy = region.max.x + 1, region.max.y + 1
	# TODO: 黒ぶち
	image = Image.new("RGB", (imgx, imgy), WHITE)
	draw = ImageDraw.Draw(image)
	#draw.rectangle([(0,0), (width,height)], outline=BLACK)
	offset = padding + border_thick
	draw_rectangle(
		draw,
		[
			(offset, offset),
			(output_width - offset, output_height - offset)
		],
		color=BLACK,
		width=border_thick
	)
	
	#resample = Image.NEAREST
	resample = Image.BILINEAR
	resized_image = src_image.resize(
		(
			output_width - (padding + frame_thick) * 2,
		  output_height - (padding + frame_thick) * 2
		),
		resample=resample
	)
	image.paste(resized_image, (
		padding + frame_thick,
		padding + frame_thick
	))
	return image

def demo():
	#content = gradient_atkinson_image(190, 190)
	content = gradient_atkinson_image(90, 90)
	frame = frame_image(content, 1024, 1024, 60, 10, 160)
	# frame = frame_image(content, 1024, 1024, 60, 20, 160)
	frame.show()

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

def brightness(r, g, b, brightnessValue=None):
	# FIXME
	mono = int(float((r + g + b) / 3.0))
	if brightnessValue is not None:
		mono += brightnessValue
		if mono > 255:
			mono = 255
		elif mono < 0:
			mono = 0
	return mono

def atkinson(src_img, brightnessValue=None):
	src_rgb_img = src_img.convert('RGB')
	width, height = src_img.size
	result_img = Image.new('RGB', (width, height))
	
	gray_array_length = width * height
	gray_array = [0] * gray_array_length
	for y in range(height):
		for x in range(width):
			r, g, b = src_rgb_img.getpixel((x, y))
			bright_temp = brightness(r, g, b, brightnessValue)
			
			# brightness correction curve
			bright_temp = int(math.sqrt(255.0) * math.sqrt(bright_temp))
			if bright_temp > 255:
				bright_temp = 255
			elif bright_temp < 0:
				bright_temp = 0
			
			darkness = int(255 - bright_temp)
			index = y * width + x
			darkness += gray_array[index]
			if darkness >= 128:
				result_img.putpixel((x, y), (0, 0, 0))
				# TODO: specify dark_color with atkinson's argument
				darkness -= 128
			else:
				result_img.putpixel((x, y), (255, 255, 255))
						
			darkn8 = int(round(float(darkness) / 8.0))

			# Atkinson dithering algorithm
			if index + 1 < gray_array_length:
				gray_array[index + 1] += darkn8
			if index + 2 < gray_array_length:
				gray_array[index + 2] += darkn8
			if index + width - 1 < gray_array_length:
				gray_array[index + width - 1] += darkn8
			if index + width < gray_array_length:
				gray_array[index + width] += darkn8
			if index + width + 1 < gray_array_length:
				gray_array[index + width + 1] += darkn8
			if index + width * 2 < gray_array_length:
				gray_array[index + width * 2] += darkn8
	return result_img

def main():
	img = Image.open('test:Lenna')
	# img.show()
	
	# inverted_img = invert(img)
	# inverted_img.show()
	
	# blured_img = blur(img)
	# blured_img.show()
	
	atkinson_img = atkinson(img)
	atkinson_img.show()

if __name__ == '__main__':
	# main()
	# gradient_demo()
	# gradient_atkinson_demo()
	demo()
