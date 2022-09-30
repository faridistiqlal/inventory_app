// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class DetailGaleri extends StatefulWidget {
  final String dGambar, dDesa, dJudul;
  const DetailGaleri(
      {Key? key,
      required this.dGambar,
      required this.dDesa,
      required this.dJudul})
      : super(key: key);

  @override
  DetailGaleriState createState() => DetailGaleriState();
}

class DetailGaleriState extends State<DetailGaleri> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.black,
        title: Column(
          children: [
            desa(),
            judul(),
          ],
        ),
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            gambar(),
            const Divider(),
            // desa(),
            // judul(),
          ],
        ),
      ),
    );
  }

  Widget gambar() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return SizedBox(
        width: mediaQueryData.size.width,
        height: mediaQueryData.size.height * 0.3,
        child: PhotoView(
          imageProvider: NetworkImage(
            widget.dGambar,
          ),
        ));
    // Column(
    //   children: <Widget>[
    //     // Image.network(
    //     //   "${widget.dGambar}", //NOTE api gambar detail event
    //     // ),
    //     CachedNetworkImage(
    //       imageUrl: widget.dGambar,
    //       // new NetworkImage(databerita[index]["kabar_gambar"]),
    //       placeholder: (context, url) => Container(
    //         decoration: const BoxDecoration(
    //           image: DecorationImage(
    //             image: AssetImage(
    //               "assets/images/load.png",
    //             ),
    //             fit: BoxFit.cover,
    //           ),
    //         ),
    //       ),
    //       width: mediaQueryData.size.width,
    //       height: mediaQueryData.size.height * 0.3,
    //       // fit: BoxFit.none,
    //     ),
    //   ],
    // );
  }

  Widget desa() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        widget.dDesa,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          //fontSize: 16.0,
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
        maxLines: 1,
      ),
    );
  }

  Widget judul() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        widget.dJudul,
        //overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 12.0,
          color: Colors.white,
        ),
        //maxLines: 1,
      ),
    );
  }
}

class Sales {
  final String year;
  final int sales;

  Sales(this.year, this.sales);
}
