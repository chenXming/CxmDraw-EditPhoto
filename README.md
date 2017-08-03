# CxmDraw-EditPhoto
一个自定义相机页面，并且带有绘画功能的Demo
主要的技术点：<br>
* 采用`AVCaptureSession`自定义相机页面.`UIImagePickerController` 局限性比较大，好处是比较简.对应文件`GetPhotoViewController`
* 有手势绘图功能. 调节线的粗细、颜色、图片灰度、绘制记录、橡皮擦、以及保存绘制图形功能.对应文件`CXMDrawerView`
* 拍照后的图片裁剪. 图片自定义裁剪，以及旋转.对应文件`TKImageView`、`EditPhotoViewController`
