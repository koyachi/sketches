from PIL import Image
import photos
import ui
import io
import image_processor

# too slow ;-(
def get_all_assets():
	all_assets = photos.get_assets()
	print('got assets.')
	for i in range(10):
		print(f'i = {i}')
		asset = all_assets[i]	
		img = asset.get_image()
		print(f'got image: {img}')
		img.show()
		print('showed image.')

def get_test_album_assets():
	for album in photos.get_albums():
		if album.title == 'Test Album':
			test_album = album
			break
	return album.assets

# via https://qiita.com/kermit71/items/8212028db5fccc9f27fe
def conver_image_pil2ui(image_in):
	with io.BytesIO() as bio:
		image_in.save(bio, 'JPEG')
		image_out = ui.Image.from_data(bio.getvalue())
	del bio
	return image_out

def main():
	view = ui.load_view('gallery')
	view.present('sheet')
	assets = get_test_album_assets()

	#for asset in assets:
	#	asset.get_image().show()

	for i in range(len(assets)):
		image_id = f'imageview{i}'
		# view[image_id].image = assets[i].get_ui_image()
		# view[image_id].image = conver_image_pil2ui(assets[i].get_image())
		
		image = assets[i].get_image().resize((80, 80))
		atkinson_image = image_processor.atkinson(image)
		view[image_id].image = conver_image_pil2ui(atkinson_image)

if __name__ == '__main__':
	main()
