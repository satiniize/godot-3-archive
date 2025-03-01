GDPC                                                                             	   D   res://.import/icon.png-487276ed1e3a0c39cad0279d744ee560.s3tc.stex   P      �      �Y�B�X�	kl+�   res://debug.tscn�            �?o������"|�N�U   res://default_env.tres  �      �       um�`�N��<*ỳ�8   res://icon.png  �*      i"      $*͖��� ��!���   res://icon.png.import   �      H      b��<l^'� 2�[Գ�   res://player.gd.remap   �*      !       �ؿk�5s0n��;P   res://player.gdc0!      �      H ����$&���s��"   res://player.tscn   �&      �      �����tl@������   res://project.binary`M      ?	      ~T�9wS! ��f�K[gd_scene load_steps=4 format=2]

[ext_resource path="res://icon.png" type="Texture" id=1]
[ext_resource path="res://player.tscn" type="PackedScene" id=2]

[sub_resource type="SpatialMaterial" id=1]
albedo_texture = ExtResource( 1 )
uv1_triplanar = true

[node name="debug" type="Spatial"]

[node name="Player" parent="." instance=ExtResource( 2 )]
transform = Transform( 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 2, 0 )

[node name="CSGBox" type="CSGBox" parent="."]
material_override = SubResource( 1 )
use_collision = true
width = 16.0
depth = 16.0

[node name="CSGPolygon" type="CSGPolygon" parent="CSGBox"]
transform = Transform( 1, 0, 0, 0, 1, 0, 0, 0, 1, 3, 1, 1 )
polygon = PoolVector2Array( -1, 0, 5, 3, 5, 0 )
depth = 2.0

[node name="OmniLight" type="OmniLight" parent="."]
transform = Transform( 1, 0, 0, 0, 1, 0, 0, 0, 1, -3, 5, 2 )
light_color = Color( 0, 1, 0, 1 )
light_energy = 2.0
omni_range = 20.0

[node name="OmniLight2" type="OmniLight" parent="."]
transform = Transform( 1, 0, 0, 0, 1, 0, 0, 0, 1, 2, 5, 2 )
light_color = Color( 0, 0, 1, 1 )
light_energy = 2.0
omni_range = 20.0

[node name="OmniLight3" type="OmniLight" parent="."]
transform = Transform( 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 5, -2 )
light_color = Color( 1, 0, 0, 1 )
light_energy = 2.0
omni_range = 20.0

[editable path="Player"]
          [gd_resource type="Environment" load_steps=2 format=2]

[sub_resource type="ProceduralSky" id=1]

[resource]
background_mode = 2
background_sky = SubResource( 1 )
             GDST@   @       ���m�Fn�baꪪ��*�    �a�* �������b��   �������b��   �������b��   �������b��   �������b��   �������b��   �������b��   �������b��   �������b��   �������b��   �������b��   �������b��  �*Z    �a�ꨀ��M���ba�����*P   �a�+*
 �������       �������       �������       �������       �������       �������       �������       �������       �������       �������       �������       �������       �������       �������      �* � @�a�訠 �������b �������       �������       �������       ��������     �������1�U�	� �������1�u�� �������1�UVTX �������1�U�% �������1�]��� �������1�UW` ��������     �������       �������       �������       �������b���� �������b �������       �������       �������       ���������� �������1�TT\\ �������       �������1�S	�U �������1��`U �������       �������1�55 ��������TTVW �������       �������       �������       �������b���� �������b �������       �������1�U�5� �������1�U`
� �������1��%�� �������1�\VUU �������       �������       �������       �������       �������1�5�UU �������1�WX� �������1�U	�� �������1�UV\r �������       �������b���� �������b ������!�UU� �������1����� �������       ��������XUUU �������       �������       �������       �������       �������       �������       ��������%UUU �������       �������1�K�?? ������!�UUVT �������b���� �������b ��������UUU �������1���� �������       �������       �������       �������       �������       �������       �������       �������       �������       �������       �������1�?�Kr ��������TUUU �������b���� �������b �������       ������e)����� �������       �������1���C �������1a� �U �������1�UW\[ �������1�UUU �������1�UUUT �������1�U�5� �������1a� �U �������1����� �������       ������e)�RRRR �������       �������b���� �������b �������       ������e)����� �������       �������1abc� ������$!aUUU> ������E)�QYXT �������1�5555 �������1�\\\\ ������E)�Ee% ������$!aUUU� �������1a���� �������       ������e)�RRRR �������       �������b���� �������b �������       ������e)����� �������       ������e)�5UUU �������1��UUU �������       �������1�5�UU �������1�\WUU �������       �������1�UUU ������e)�\UUU �������       ������e)�RRRR �������       �������b���� �������b �������       �������1���� �������1��*UU �������1�~��% ��������     �������1�UՕ �������1�U� V �������1�U� � �������1�UWVT ��������     �������1��ZX �������1���UU �������1�PRRR �������       �������b���� �������b �������       �������1��%5� ������e)�UUWT �������1�55�U �������1�W �U �������1�*�U ������$!�TTWU ������$!��U �������1�T��U �������1�� �U �������1�\\WU ������e)�UU� �������1�ZX\V �������       �������b���� �������b �������       ��������UUU �������1��㍵ �������1�UUWx �������       �������       �������       �������       �������       �������       �������1�UU�- �������1�/�r^ ��������TUUU �������       �������b���� �������b �������       �������       �������       �������1��UU �������1����U �������1���U �������1�U_ U �������1�U� U �������1����U �������1��~U �������1��^UU �������       �������       �������       �������b�����*0  �a*+� �������       �������       �������       �������       �������       �������       �������       �������       �������       �������       �������       �������       �������       �������      �* ` 
 �a������o�i�ba�����*    �N�a*�� �������b  �� �������b  �� �������b  �� �������b  �� �������b  �� �������b  �� �������b  �� �������b  �� �������b  �� �������b  �� �������b  �� �������b  ���*    �5�a�����?���m�baꪪ��������a�* �������b�    �������b�    �������b�    �������b�    �������b�    �������b�   �!���?�a���� �������b �������       ������E)���� ������%)�zN�� ������%)����� ������E)�WPsS �������       �������b���� �������bUUU ������E)��!�� ������E)����� �������       �������       ������E)�c/�� ������E)�{H/? �������bUUUT �������b=��� ������E)����� ������e)b��Z ������$!�UUW� ������$!�UU� ������e)b���� ������E)�?�OO �������b| �������b ������E)����� ������E)a\�� ������E)��U ������E)���VU ������E)a5��� ������E)�OOOO �������b���� �������b ������e)���� ������e)�XQ�� ������E)���rZ ������E)�_b�� ������e)�%EJ_ ������e)�@OOk �������b���� �������b ������E)��UU ������E)����� ������$!�UU~ ������$!�UU�� ������E)����W ������E)�STUU �������b���������o0�a*� �������b   � �������b   � �������b   � �������b   � �������b   � �������b   ����a�ਪL�ȟ�����b� ������!�UU�1 ������!�UUcLL��?����b���� ������!�5��� ������!�^UU� ������!��UU/ ������!�\SS[ ������!���%� ������$!�$�,� ������$!��8� ������!�[[XZL�������!bUUU ������!��
UU ������!���UUL������!bTUUU���������bU%����������bUXB@��������!b�	�U�������!bj`zU�������� �}��}���   ��������     �A  ����            [remap]

importer="texture"
type="StreamTexture"
path.s3tc="res://.import/icon.png-487276ed1e3a0c39cad0279d744ee560.s3tc.stex"
path.etc="res://.import/icon.png-487276ed1e3a0c39cad0279d744ee560.etc.stex"
metadata={
"imported_formats": [ "s3tc", "etc" ],
"vram_texture": true
}

[deps]

source_file="res://icon.png"
dest_files=[ "res://.import/icon.png-487276ed1e3a0c39cad0279d744ee560.s3tc.stex", "res://.import/icon.png-487276ed1e3a0c39cad0279d744ee560.etc.stex" ]

[params]

compress/mode=2
compress/lossy_quality=0.7
compress/hdr_mode=0
compress/bptc_ldr=0
compress/normal_map=0
flags/repeat=true
flags/filter=true
flags/mipmaps=true
flags/anisotropic=false
flags/srgb=2
process/fix_alpha_border=true
process/premult_alpha=false
process/HDR_as_SRGB=false
process/invert_color=false
stream=false
size_limit=0
detect_3d=false
svg/scale=1.0
        GDSC      
      �      ������������϶��   ��������ƶ��   �������Ӷ���   ����������������϶��   ��������Ķ��   �������϶���   �����¶�   ����¶��   ��������������������ض��   �������ض���   ζ��   �������Ӷ���   ϶��   ���������������Ŷ���   ����׶��   �������¶���   ������������¶��   ����¶��   ������������������޶   ����������¶   ����������Ķ   ��������۶��   ����Ŷ��   ̶��   ����Ŷ��   �涶   ���������Ҷ�   ��������Ķ��   �������������Ӷ�      CamGroup  {�G�z�?               
   move_right     	   move_left         move_up    	   move_down         A  ������#@                                                    	      
   $      *      :      J      e      f      m      r      s      z      �      �      �      �      �      �      �      �      �      �      3YY5;�  �  PQYY;�  �  YY;�  Y;�  V�  YY0�  P�  QV�  &�  4�  V�  �  T�	  T�
  P�  T�  T�  �  Q�  �  T�	  T�  P�  T�  T�
  �  Q�  �  T�	  T�
  �5  P�  T�	  T�
  R�  Z�  RZ�  QYY0�  P�  QV�  �  P�  QYY0�  P�  QV�  ;�  �  T�  P�  Q�  T�  P�  Q�  ;�  �  T�  P�  Q�  T�  P�  Q�  ;�  P�  T�  T�  T�  QT�  P�  T�  QT�  PQ�  ;�  �  T�  P�  T�  Q�  �  �  �  �  �  �  �  �  T�  PQ�  �  T�
  �  T�
  �  �  �  T�  �  T�  �  �  �  T�  �	  �  �  �  �  P�  QY`    [gd_scene load_steps=5 format=2]

[ext_resource path="res://player.gd" type="Script" id=1]

[sub_resource type="CapsuleShape" id=1]
radius = 0.5

[sub_resource type="SpatialMaterial" id=2]
params_diffuse_mode = 4
params_specular_mode = 3
metallic_specular = 1.0
roughness = 0.0

[sub_resource type="CapsuleMesh" id=3]
material = SubResource( 2 )
radius = 0.5

[node name="Player" type="KinematicBody"]
script = ExtResource( 1 )

[node name="CollisionShape" type="CollisionShape" parent="."]
transform = Transform( 1, 0, 0, 0, -4.37114e-08, -1, 0, 1, -4.37114e-08, 0, 0, 0 )
shape = SubResource( 1 )

[node name="MeshInstance" type="MeshInstance" parent="."]
transform = Transform( 1, 0, 0, 0, -4.37114e-08, -1, 0, 1, -4.37114e-08, 0, 0, 0 )
mesh = SubResource( 3 )
material/0 = null

[node name="CamGroup" type="Spatial" parent="."]

[node name="ClippedCamera" type="ClippedCamera" parent="CamGroup"]
transform = Transform( 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 64 )
fov = 16.0
size = 16.0
clip_to_bodies = false
[remap]

path="res://player.gdc"
               �PNG

   IHDR   @   @   �iq�  �zTXtRaw profile type exif  xڭ�i����sY�8���xNv���+�v������OK2-� 
(dֿ���?���b.��t�j��qQ�������9���������ǐ���%=������q�&*��C��C}��ʗ��}�H��1Q}L����}L��m]��������|���F�P>���{�{3��wny�/�·� �k|���\[���g�i	��OכU�+*�+���P|�����^��m�2�������k�O�_��v��{�b�^��ZH�4=6��ʹ�Ǝ��y,���G���T>���'�u>�V�����N��뜇��r��s�4V|v�P
�����~��x�̻�-��[�r���;�e2�������:���Wy�
���3���� v?�(??_����x�\�`��=E��[�#���9߹f�|L��X;bQ�,��앝����>��
I�:���J�O�S���lϽ.�{����T ��U�؈�
1Ԣ�!Ƙb�%�ؒO!ŔRN"��}9�s.��V|	%�Tr)��Ҫ�r�5�\K��5m��x�qCk�u�C�=��K���g�Gy3�h�M?቙f�e�ٖ]��
+���*���	��w�q��w�u�j�ܰ~��9j���;H���B�Gs~NaE'Q���ĳ ��0���A'̮�Ȋ�2
�i��e]����r�p3!�O��'rF��?�3�����jS�f\����r��I?nXm���ce�f���G���r�3�D%��A9�&�����h��1���?~N�6l��a�\z^����ć1�VD|{�=uG�a]<Pu�|=D���og�W7���9֎���`8}�ư5�]]W<w��s�v�؁��kF�w��Y8_��O�@�Ժ���Vݽ��'ɖ�嶣�є��&
5T@�0����7��B-��DڬX�h�9��=߭�hwe��l?	ئ�T�w�=f�qo�܋Օ����2f{�+6���Xѳ��J`��m����e��z�Ǵ��"���h�3�6gZ�[�6���_�"�SS�4������)�U%���n���[���[Қmy�l+c���V��Vcܽ=��(5���z�c�姫%��&��m��������$��[��ow�v�,:�"����FJsX�����ec��	�K��z��p�؄��F���tbzW=\g�O�SK}^�� �jem�{����H�E_��OG��jm��N�_�p�!��6�`�����~��E���c^W��֞p^���3�>����A`��!��Z�~�Ƕ��v'-q~`�ځ�Sf�@�`aafƺ��?���J?�G�����<D�6xZ�j��
5g�?tȜ�E��L<,�����h5���UwY9-H�E�%���7�<�|PN�iuACԳ��f�ړnJx�g���<��O��U�W��|�g6��"�~:�c��Z�o8X*���z/��S$d����]p IJ�La�G�&<ҽQ;�" ��K��ێ���Gq��'xSi=l�r���¤�
+AC,��N����WW޹:�%���˹Qg;B� &�� g���"�N��c���F�7�rCߝmQ%Ύ��yK��Yx�@�Г#������s�=ͮR�B�dX���4�π��_Q�a2�˳��ad:���N�׬='9���ʲG����l��@�3C%
�n�29����Z.I�4�
����9�$.N1�!Gϧ��`jkŔ��ÅPH���� ,�׊�5%��	xUYR��M�9F�����s�������H�G��1���홆��=F�[�FT���z�S�~�&a��~��7)?�N�{�,D����'���G|��AHa�W��qv�}[�P��y���QyH�!g���I52_L�����op�U�\�qD��X�bm�eES�=.54oۀ��+���И�[+v�,�SR'�S�qb+\�)����~�&�D�" �n�k_�r{���*W
���o~@a�B�w�V�'�s\��oP�R�QȺ"%.a��٪^��L��o����t��fJ�^�c�(O�u�\ʻ��$�SA��IfKs4��x���Rn'x��F~z��qǸ�����o���1Y����$��Zc�<�g:@]$$�S��N�zJ��0��S�y=i�'ys;��,ڹ�5k+��*�D��몭 wJP:�<��r0z��:e7���8bj�	%���~x�R�K���	R
��t�uc�@�g�4�$�[�)��pRi�!��ό9���Ar:�I���B`n�*��"� ;GjH�#�m.���Al��)4.�#�fEu�`��u����=�פ*�d��O�ϊ��J���-��(����wa!�Mr�YI\�o��� �Ya�z�9ՋD]-���G�%��GQ�\ua��t*A��BU9����J�Xt7���):;߬z��&�1����H�p_܏o��.�>9�~����l4i�/u{&,��fA�e^��?�_-pQ���a�4�P]�և�T�H��TY�'��]zt*��S0�X�����Uߤ�Xr�-�w�u4Ҝ��nfӔMԅUt�z�p�k�uPczZ���tȌg�P�h�o*�Í�|�.CR?�;F/���j��<����R�q�L-��!)M"0�8�ڐ
|��C#�N	[�>���E0Qчpڸ�k]��h�i�i�cCy���������CS=�ܟ�R)�WO��b�E6���D�kP"�~JC{�%$��+�=LW樂��ޔ�<PO���Xڠ���oA���{�`i���dS�mQ��qQ�I�E~𣟗0�$����e��g�����0��aY����b���=��-��?�<Qp4�S��M��ky1#C�>��t%�O�Kw��8t(:��iP1��G������!�g��:T(I�"��G�r���H.A{)�6앤���A�
����*�i)�d  �iCCPICC profile  x�}�=H�@�_ӊR*v�P�����T�J[�U�K��IC���(��X�:�8���*� nnN�.R���B�������� 4*L5��YF*��U��A#�1D$f��b���>��Ey���?G��7���nX��3���y�8�J�B|N<n���.��ƹ��3�F&5O&�,w0+*�4qDQ5��.+��8��kݓ�0��V�\�9�8��@"d�PF��j��H�~��?�����U#��P!9~�?�ݭY��t�B1��Ŷ?F��]�Y���c�n� �g�Jk��`���z[�}���u[����`�I�ɑ�4�Bx?�o���@p������ C]-� ��h���=����ۿgZ�� ��rō���  iTXtXML:com.adobe.xmp     <?xpacket begin="﻿" id="W5M0MpCehiHzreSzNTczkc9d"?>
<x:xmpmeta xmlns:x="adobe:ns:meta/" x:xmptk="XMP Core 4.4.0-Exiv2">
 <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about=""
    xmlns:xmpMM="http://ns.adobe.com/xap/1.0/mm/"
    xmlns:stEvt="http://ns.adobe.com/xap/1.0/sType/ResourceEvent#"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:GIMP="http://www.gimp.org/xmp/"
    xmlns:tiff="http://ns.adobe.com/tiff/1.0/"
    xmlns:xmp="http://ns.adobe.com/xap/1.0/"
   xmpMM:DocumentID="gimp:docid:gimp:36aa1e6e-d83a-42e5-aaa8-3dadd1d6f09f"
   xmpMM:InstanceID="xmp.iid:010846e4-cab8-4bca-8428-ce564e429462"
   xmpMM:OriginalDocumentID="xmp.did:93fae2b1-a7bc-4e27-8129-6df8d91509a1"
   dc:Format="image/png"
   GIMP:API="2.0"
   GIMP:Platform="Windows"
   GIMP:TimeStamp="1635655654772089"
   GIMP:Version="2.10.24"
   tiff:Orientation="1"
   xmp:CreatorTool="GIMP 2.10">
   <xmpMM:History>
    <rdf:Seq>
     <rdf:li
      stEvt:action="saved"
      stEvt:changed="/"
      stEvt:instanceID="xmp.iid:daeeed09-5c6c-4193-b8f0-48c0301c020c"
      stEvt:softwareAgent="Gimp 2.10 (Windows)"
      stEvt:when="2021-10-31T11:47:34"/>
    </rdf:Seq>
   </xmpMM:History>
  </rdf:Description>
 </rdf:RDF>
</x:xmpmeta>
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                           
<?xpacket end="w"?>~��   bKGD @ @ @��/f   	pHYs     ��   tIME�
/"⮬  �IDATx��[ێ�J]�n��u�����xF�����C?�yA���� xD�#�{3b.Ɍ����[��q��fϔ)���VUW��nX��~��%����؏���1����4�W�w��!��ѯc^�Q��C�$�[���/ ~�00�^��h۶��_�$�@�?[�[ �R�s�aƫ�|�1l�vQ��ߌ�k�� ��d�=�!#��1 � p �z��tt |�c_)7y+�te�}� |x+������@�u]!v�W�u��#߉S]�s���8l���'I�����1����@.�Y�AJ��iN2��0MQ�u] @Y��R�(
ض� �$	������Z��(�EV����Ƹ�a����a�R"��'�#"���(�pss�dlE "dY"B]�H��s�f3�����K|��q�����<p�qww�4M7ܖ���)\��l6�i�0MS+��)��ɘ�i��)����9��y/��e�X��ښ��y�3uMi��P�oZD���Gp�7Ʈ[=�v��ؕ�ʲ<��L�A1`[>7M�"U����iR����j��b���a�����>�>�»�,K�u��|)%���Ѷ-���X��!���YA��5�M�0DǐR�m[�����f�,RJ�izR��y|�GY����� �4�a�}�����{-׽<�u]�q�,˴���a���X,Nb�uI�UU���aj��(�q��k�V��=�s���ߣ�k,�޵׶�ɨ�PV0u]o��1������y��wF��� ��Ru]?��J�>�sUs?8x��qNZ��
)%����,M� ˲/��ϲM�������
��'��"�m�s��z@��a�L�/I8��EQ@Jy����'���.j�j�G�ҟm�p���a�:P��NB�����x��3��8,�cM�`�ZM�,˂�����P��n�l��t�I�A����u� "!`�6�$ً�mc�ʝ�5-˂�8���,���VA�(
��� �sJE[$�Q}�X�� �\.�������m#C,���K�1۶AD����]"���-���iT��|��|�[�ڶ)%noo5@y����D۶')�����|Q�97˲^����!z	XUU(���� �b����1�^S��I ���in�I��0<��_U�0� �q��9Y6I���� puu� 4WWWz���5��A�k�{��,����ٙnwV��$����,�\.�y޽{�=��k,�˽Hγ�&vww����EQhpTP��R;Dm�N��O��1C�NՏx;��� ���.�Ho`*��׺>u�s�y��B0��k����ipΟL��C%�eY;�
M�Pq�n��m�8c�( �<���+�}�ߺkӭ�w�7L��a�ѡ<�+���M���CVM��v��b�K���`��{�mi�16jyo �{�Ҧi����ت��N��*��[�%�1�aCq�s>�#�`�#�P��hå�M���5��̐���ҫ������<�Ѷ�>j�֫��"GC�,K��JfY�߫`��8)�"V��)�0����7P�{�-����M�eY�ڠE� �@�/�Єa!��"i �L��8/
�0�8������Z@m<�q�4�$ɳl�o#V�[�s&��W�{@b]f�...tnϲlT�9F��mۚ8�0J��u?�V�*�OU�2� �Ѝu���ǃ�>) J\�ݠ��v�JaD��w�թ���	j>�e=���
i���p2 �\ݶm��+��U]E�_S�uFh��m�<�{פB[���S�1U�k�,@D׌��縙Rl��Gȿc�c[Y_�tt�����
��&JW"���@�V���c�;^U���&���H�Z��x�o��R�� ������/ ���� �0{�+ ������������~ҋh��    IEND�B`�       ECFG      application/config/name      
   adumekanik     application/run/main_scene         res://debug.tscn   application/config/icon         res://icon.png     display/window/vsync/use_vsync             display/window/stretch/shrink         @   input/move_up�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device            alt           shift             control           meta          command           pressed           scancode   W      physical_scancode             unicode           echo          script         input/move_down�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device            alt           shift             control           meta          command           pressed           scancode   S      physical_scancode             unicode           echo          script         input/move_left�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device            alt           shift             control           meta          command           pressed           scancode   A      physical_scancode             unicode           echo          script         input/move_right�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device            alt           shift             control           meta          command           pressed           scancode   D      physical_scancode             unicode           echo          script      )   physics/common/enable_pause_aware_picking         $   rendering/quality/driver/driver_name         GLES2   %   rendering/vram_compression/import_etc         &   rendering/vram_compression/import_etc2          3   rendering/quality/shading/force_lambert_over_burley         .   rendering/quality/shading/force_blinn_over_ggx            rendering/quality/depth/hdr          )   rendering/environment/default_environment          res://default_env.tres   