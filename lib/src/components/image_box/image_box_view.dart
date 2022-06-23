import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:my_things/src/common/common.dart';

enum ImageBoxViewMode {
  FILE,
  NETWORK
}

class ImageBoxView  extends StatefulWidget {
  final String  imageUrl;
  final double  boxHeight;
  final bool    onTapFullScreenEnabled;
  final ImageBoxViewMode _mode;    
  

  const ImageBoxView.network(this.imageUrl, this.boxHeight ,{ Key? key, this.onTapFullScreenEnabled = false}) 
      : _mode = ImageBoxViewMode.NETWORK,  super(key: key) ;

  const ImageBoxView.file(this.imageUrl, this.boxHeight ,{ Key? key, this.onTapFullScreenEnabled = false})
      : _mode = ImageBoxViewMode.FILE,  super(key: key) ;
  
  @override
  State<StatefulWidget> createState() => _ImageBoxViewState();
  
}

class _ImageBoxViewState extends State<ImageBoxView> {
  late Image    _image;
  bool          _loading = true;

  @override
  void initState() {
    _image = widget._mode == ImageBoxViewMode.NETWORK ? Image.network(widget.imageUrl) : Image.file(File(widget.imageUrl));
    _image.image.resolve(const ImageConfiguration()).addListener(ImageStreamListener( (info, call)  {
      setState(() {
        _loading = false;
      });
    }));
    super.initState();
  }

  Dialog fullScreenImage(BuildContext context, String imageUrl) {
    return Dialog(//this right here
      child: Card(
        child: _image,
        elevation: 5,
      )
    );
  }

  Widget imageContainer (){
    return Container(
      height: widget.boxHeight,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        image: DecorationImage(
          fit: BoxFit.fitWidth,
          alignment: FractionalOffset.center,
          image: _image.image,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: _loading
            ?  const Center(child: CircularProgressIndicator())
            : widget.onTapFullScreenEnabled
              ? GestureDetector(
                onTap: (){
                  showDialog(context: context, builder: (BuildContext context) => fullScreenImage(context, widget.imageUrl)) ;
                },
                child: imageContainer(),
              )
              : imageContainer()
    );
  }
}

