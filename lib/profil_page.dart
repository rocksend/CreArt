import 'package:flutter/material.dart';
import '../creart_store.dart';
import 'tentang_page.dart';
import 'detail_postingan_page.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});
  @override State<ProfilPage> createState() => _ProfilPageState();
}
class _ProfilPageState extends State<ProfilPage> {
  bool _saved = false;
  final store = CreArtStore.instance;
  @override Widget build(BuildContext context) => AnimatedBuilder(
    animation: store, builder: (context, _) {
      final items = _saved ? store.savedArtworks : store.myArtworks;
      return Scaffold(
        appBar: AppBar(title: const Text('Profil kreator', style: TextStyle(fontWeight: FontWeight.bold)),
          actions: [IconButton(icon: const Icon(Icons.info_outline), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TentangPage())))],
        ),
        body: ListView(padding: const EdgeInsets.only(bottom: 24), children: [
          const SizedBox(height: 18),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            CircleAvatar(radius: 42, backgroundColor: const Color(0xFFE9DDFB), child: Icon(Icons.person, size: 44, color: Theme.of(context).colorScheme.primary)),
            const SizedBox(width: 16),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(store.userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              Text('@${store.username}', style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 4), const Text('Kreator CreArt', style: TextStyle(color: Color(0xFF7052C8), fontSize: 12))
            ])
          ]),
          Padding(padding: const EdgeInsets.fromLTRB(24,16,24,12), child: Text(store.bio, textAlign: TextAlign.center)),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Row(children: [
            _stat('${store.myArtworks.length}', 'Karya'), _stat('${store.totalLikes}', 'Apresiasi'), _stat('${store.savedArtworks.length}', 'Disimpan')
          ])),
          Padding(padding: const EdgeInsets.fromLTRB(20,16,20,8), child: OutlinedButton.icon(
            icon: const Icon(Icons.edit_outlined), label: const Text('Edit profil'),
            onPressed: () => _editProfile(context))),
          Row(children: [_tab('Karya saya',false), _tab('Koleksi tersimpan',true)]),
          if(items.isEmpty) Padding(padding: const EdgeInsets.all(36), child: Column(children: [
            Icon(_saved?Icons.bookmark_border:Icons.palette_outlined,size:52,color:const Color(0xFF7052C8)),
            const SizedBox(height:12), Text(_saved?'Belum ada karya tersimpan':'Belum ada karya'),
            const SizedBox(height:6), Text(_saved?'Simpan karya yang menarik untuk referensi.':'Karya yang kamu unggah akan tampil di sini.',textAlign:TextAlign.center,style:const TextStyle(color:Colors.grey))
          ])) else Padding(padding: const EdgeInsets.all(16), child: GridView.builder(
            shrinkWrap:true, physics:const NeverScrollableScrollPhysics(), itemCount:items.length,
            gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2,crossAxisSpacing:14,mainAxisSpacing:14,childAspectRatio:.72),
            itemBuilder:(context,i)=>_artCard(context,items[i]))),
        ]),
      );
    });
  Widget _stat(String value,String label)=>Expanded(child:Column(children:[Text(value,style:const TextStyle(fontSize:20,fontWeight:FontWeight.bold)),Text(label,style:const TextStyle(color:Colors.grey,fontSize:12))]));
  Widget _tab(String label,bool saved){final selected=_saved==saved;return Expanded(child:InkWell(onTap:()=>setState(()=>_saved=saved),child:Container(padding:const EdgeInsets.symmetric(vertical:14),decoration:BoxDecoration(border:Border(bottom:BorderSide(color:selected?const Color(0xFF7052C8):const Color(0xFFE9E3F0),width:selected?2:1))),child:Center(child:Text(label,style:TextStyle(fontWeight:selected?FontWeight.bold:FontWeight.normal,color:selected?const Color(0xFF29243A):Colors.grey))))));}
  Widget _artCard(BuildContext context,Artwork art)=>InkWell(onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>DetailPostinganPage(artwork:art))),child:Container(decoration:BoxDecoration(color:Colors.white,border:Border.all(color:const Color(0xFFE9E3F0)),borderRadius:BorderRadius.circular(14)),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
    Expanded(child:Container(width:double.infinity,decoration:BoxDecoration(gradient:LinearGradient(colors:[art.color1,art.color2]),borderRadius:const BorderRadius.vertical(top:Radius.circular(14))),child:const Icon(Icons.palette_outlined,size:42,color:Color(0xFF7052C8)))),
    Padding(padding:const EdgeInsets.all(10),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(art.title,maxLines:1,overflow:TextOverflow.ellipsis,style:const TextStyle(fontWeight:FontWeight.bold)),Text(art.category,style:const TextStyle(color:Color(0xFF7052C8),fontSize:11)),Row(children:[const Icon(Icons.favorite_border,size:14,color:Colors.grey),Text('${art.likes}',style:const TextStyle(color:Colors.grey)),const Spacer(),if(_saved)IconButton(padding:EdgeInsets.zero,constraints:const BoxConstraints(),icon:const Icon(Icons.bookmark,color:Color(0xFF7052C8)),onPressed:()=>store.toggleSave(art))])]))])));
  Future<void> _editProfile(BuildContext context) async {
    final name=TextEditingController(text:store.userName), username=TextEditingController(text:store.username), bio=TextEditingController(text:store.bio);
    await showDialog(context:context,builder:(ctx)=>AlertDialog(title:const Text('Edit profil'),content:SingleChildScrollView(child:Column(mainAxisSize:MainAxisSize.min,children:[TextField(controller:name,decoration:const InputDecoration(labelText:'Nama')),TextField(controller:username,decoration:const InputDecoration(labelText:'Username')),TextField(controller:bio,maxLines:3,decoration:const InputDecoration(labelText:'Bio'))])),actions:[TextButton(onPressed:()=>Navigator.pop(ctx),child:const Text('Batal')),ElevatedButton(onPressed:(){store.updateProfile(name:name.text.trim(),username:username.text.trim(),bio:bio.text.trim());Navigator.pop(ctx);},child:const Text('Simpan'))]));
    name.dispose();username.dispose();bio.dispose();
  }
}
