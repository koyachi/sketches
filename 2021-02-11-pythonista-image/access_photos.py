from PIL import Image
import photos

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

def main():
	assets = get_test_album_photos()
	for asset in assets:
		asset.get_image().show()

if __name__ == '__main__':
	main()
