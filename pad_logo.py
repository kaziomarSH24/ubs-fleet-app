import sys
from PIL import Image

try:
    img = Image.open('assets/images/logo.jpg')
    print(f"Format: {img.format}, Size: {img.size}, Mode: {img.mode}")
    # pad the image by 20% on all sides
    w, h = img.size
    new_w = int(w * 1.5)
    new_h = int(h * 1.5)
    
    # get corner color to use as padding background
    bg_color = img.getpixel((0, 0))
    if img.mode != 'RGB':
        img = img.convert('RGB')
        bg_color = img.getpixel((0, 0))
        
    print(f"Background color detected as: {bg_color}")
    
    new_img = Image.new('RGB', (new_w, new_h), bg_color)
    new_img.paste(img, ((new_w - w) // 2, (new_h - h) // 2))
    new_img.save('assets/images/logo_padded.jpg')
    print("Saved assets/images/logo_padded.jpg")
except Exception as e:
    print("Error:", e)
