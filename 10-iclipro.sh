cd /home/miav/GSE116561/deduped_files

for bam_file in /home/miav/GSE116561/deduped_files/*bam; do

# extract basename
base_name=$(basename "$bam_file" .bam)

iCLIPro -r 50 -b 300 -f 50 -g "L15:15,L16:16,L17:17,L18:18,L19:19,L20:20,L21:21,L22:22,L23:23,L24:24,L25:25,L26:26,L27:27,L28:28,L29:29,L30:30,L31:31,L32:32,L33:33,L34:34,L35:35,L36:36,L37:37,L38:38,L39:39,L40:40,R:41" -p "L15-R,L16-R,L17-R,L18-R,L19-R,L20-R,L21-R,L22-R,L23-R,L24-R,L25-R,L26-R,L27-R,L28-R,L29-R,L30-R,L31-R,L32-R,L33-R,L34-R,L35-R,L36-R,L37-R,L38-R,L39-R,L40-R" -o /home/miav/GSE116561/iclipro_output $base_name.bam

done

