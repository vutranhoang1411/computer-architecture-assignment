##########################################
# BAI TAP LON KIEN TRUC MAY TINH - HK211
# DE TAI 8: Merge sort so nguyen
##########################################

##########################################
# DATA SEGMENT 
	.data 
# Cac bien dung trong chuong trinh
file:		.asciiz	"F:/KTMT/INT15.bin"	# Luu tru ten file
arr: 		.word 	1,2,3,4,5,6,7,8,9,10,11,12,13,14,15 # Luu tru mang gom 15 so nguyen
size: 		.word 	15		# Luu tru so phan tu cua mang

# Cac ki tu dung de in ra man hinh
spacechac: 	.asciiz " "		# Ki tu space dung cho khi in ra man hinh
endline: 	.asciiz "\n"		# Ki tu xuong dong dung cho khi in ra man hinh

# Cac cau nhac in ra man hinh
Nhac_1:		.asciiz "Mang khi chua duoc sap xep: \n"
Nhac_2: 	.asciiz "Cac buoc cua giai thuat Merge sort: \n"
Nhac_3:		.asciiz "Mang sau khi dung Merge sort sap xep: \n"
Nhac_4:		.asciiz "Thoi gian chay la: "
##########################################
# CODE SEGMENT
	.text
	.globl main
	
#----------------------------------------
# Chuong trinh chinh
#----------------------------------------
main:	
	#get start time
	addi   $v0, $zero, 30          # Syscall 30: System Time syscall
   	syscall                        # $a0 will contain the 32 LS bits of the system time
    	add    $t4, $zero, $a0         # Save $a0 value in $t4
    	
	# Goi ham de doc du lieu tu file vao mang
	la	$a0, file			# Truyen dia chi bien luu tru ten file cho $a0
	la	$a1, arr			# Truyen dia chi cua mang cho $a1
	lw	$a2, size 			# Truyen so phan tu cua mang cho $a2
	jal	readFile			# Goi ham readFile
	
	# In mang chua duoc sap xep ra man hinh
	li	$v0, 4			
	la	$a0, Nhac_1		
	syscall				

	la	$a0, arr		# $a0=&arr[0]
	lw	$a1, size		# $a1=arr.size
	jal	printArray		
	
	# thuc hien merge sort
	li $v0, 4			
	la $a0, Nhac_2			
	syscall		
	
	lw $t0, size			#$t0=arr.size*4
	sll $t0, $t0, 2 		
	la	$a0, arr		# $a0=&a[0]
	add	$a1, $a0, $t0		# $a1= (&a[size-1])+4
	jal	mergeSort			
	
	# In mang sau khi duoc sap xep
	li	$v0, 4			
	la	$a0, Nhac_3			
	syscall				

	la	$a0, arr			
	lw	$a1,size		
	jal printArray			

	
# Ket thuc chuong trinh
#########################################
Kthuc:	
	li	$v0,4
	la	$a0,Nhac_4
	syscall
	#get end time
	addi	$v0, $zero, 30          # Syscall 30: System Time syscall
   	syscall                        # $a0 will contain the 32 LS bits of the system time
    	add	$t5, $zero, $a0         
    	
    	sub	$t4, $t5, $t4
    	
    	li	$v0, 1
    	add	$a0,$zero,$t4
    	syscall
    	
    	#end
	li $v0, 10
	syscall
#########################################
	
#----------------------------------------
# Dinh nghia ham
#----------------------------------------

#########################################
# readFile($a0, $a1, $a2)
#########################################
# Ham readFile dung de doc du lieu tu file va luu cac gia tri vao mang
# Doi so $a0: Ten file
# Doi so $a1: Dia chi cua mang
# Doi so $a2: So phan tu cua mang
# Gia tri tra ve: Ham ko co gia tri tra ve
readFile:
	# Luu tru gia tri cua cac thanh ghi duoc dung trong ham vao stack
	addi $sp, $sp, -12
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)

	# Mo file de doc
	li $v0, 13			
	li $a1, 0			#read-only
	syscall				
	move $s1, $v0			
	
	# Tinh so bytes luu tru cua mang
	lw $t0, 8($sp)			# Load so phan tu cua mang vao $t0
	sll $t0, $t0, 2			# So byte can doc
	
	# Doc file
	li $v0, 14			# Goi syscall 14
	move $a0, $s1			# Truyen descriptor cua file vao $a0
	lw $a1, 4($sp)			# Truyen dia chi cua mang vao $a1
	move $a2, $t0			# So ki tu toi da de doc la so bytes luu tru cua mang 
	syscall				
	
	# Dong file
	li $v0, 16			# Goi syscall 16
	move $a0, $s1			# Luu descriptor cua file vao $a0
	syscall			
# Ket thuc ham readFile	
	# Load cac gia tri cua thanh ghi trong stack vao lai cac thanh ghi
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	
	# Dua stack ve trang thai ban dau
	addi $sp, $sp, 12
	
	# Tro ve noi ham duoc goi
	jr $ra				

#########################################
# mergeSort($a0, $a1)
#########################################
# Ham mergeSort dung de sap xep cac phan tu cua mang theo thu tu tang dan bang thuat toan mergesort
# Doi so $a0: dia chi cua mang
# Doi so $a1: dia chi ket thuc cua mang
# Gia tri tra ve: Ham khong co gia tri tra ve
mergeSort: 
	# Luu gia tri cac thanh ghi duoc dung trong ham vao stack
	addi	$sp, $sp, -16		
	sw	$ra, 0($sp)			
	sw	$a0, 4($sp)			
	sw	$a1, 8($sp)	
	
	sub	$t0, $a1, $a0		
	ble	$t0, 4, endMergeSort	# Ket thuc de quy khi so phan tu <=1
	
	#lay phan tu o giua			
	srl	$t0, $t0, 3		
	sll	$t0, $t0, 2		
	# ta lam nhu tren de phong truong hop mang co le phan tu
	# dan toi neu ta chi shift right 1 bit, se bi le dia chi (vd 0x00000004->0x00000002)
	add	$t0, $a0, $t0		#$t0=&arr[middle]
	sw	$t0, 12($sp)		
	
	# Merge sort nua mang ben trai
	lw	$a0, 4($sp) 			# Dia chi cua nua mang ben trai la dia chi cua mang
	lw	$a1, 12($sp)			# Dia chi ket thuc cua nua mang ben trai la dia chi cua phan tu giua mang
	jal	mergeSort			# Goi de quy ham mergeSort
	
	# Merge sort nua mang ben phai
	lw	$a0, 12($sp)			# Dia chi cua mang ben trai la dia chi cua phan tu giua mang
	lw	$a1, 8($sp)			# Dia chi ket thuc cua nua mang ben trai la dia chi ket thuc cua mang
	jal	mergeSort			# Goi de quy ham mergeSort
	
	# Merge 2 nua mang lai voi nhau
	lw	$a0, 4($sp)			# $ao luu dia chi mang
	lw	$a1, 12($sp)			# $a1 luu dia chi cua phan tu giua mang
	lw	$a2, 8($sp)			# $a2 luu dia chi ket thuc cua mang
	jal	merge			

#ket thuc ham mergeSort
endMergeSort:
	# Load gia tri cua cac thanh ghi trong stack vao lai cac thanh ghi
	lw	$ra, 0($sp)			
	lw	$a0, 4($sp)			
	lw	$a1, 8($sp)			
	addi	$sp, $sp, 16		
	jr	$ra				

#########################################
# merge($a0, $a1, $a2)
#########################################
# Ham merge dung de merge 2 nua cua mot mang lai voi nhau
# Doi so $a0: dia chi mang
# Doi so $a1: dia chi phan tu giua mang
# Doi so $a2: dia chi ket thuc mang	
# Gia tri tra ve: Ham khong co gia tri tra ve
merge:
	# Luu gia tri cac thanh ghi duoc dung trong ham vao stack
	addi	$sp, $sp, -16		
	sw	$ra, 0($sp)			
	sw	$a0, 4($sp)			
	sw	$a1, 8($sp)			
	sw	$a2, 12($sp)			
	
	move	$s0, $a0			# Luu dia chi nua mang ben trai vao $s0
	move	$s1, $a1			# Luu dia chi nua mang ben phai vao $s1

# Lap lai lan luot qua cac phan tu de sort dung vi tri
mergeloop:
	lw	$t0, 0($s0)		
	lw	$t1, 0($s1)		
	
	ble	$t0,$t1,nextElement	
	
	# chuyen sang phan tu tiep theo cua mang phai	
	move	$a0, $s1			# Truyen dia chi cua phan tu dang giu boi $s1 vao $a0
	move	$a1, $s0			# Truyen dia chi cua phan tu dang giu boi $s0 vao $a1
	jal	shiftElement		# Goi ham shiftElement 
	addi	$s1, $s1, 4		# Tang gia tri cua $s1, tuc la chuyen sang phan tu tiep theo

# Chuyen sang phan tu tiep theo cua mang ben trai	
nextElement: 
	addi	$s0, $s0, 4		# Tang gia tri cua $s0 len 4, tuc la chuyen sang phan tu ke tiep
	lw	$a2, 12($sp)			# Load dia chi ket thuc mang tu stack vao $a2
	bge	$s0, $s1, endMerge		# Neu $s0 >= $s1, da duyet qua het mang thi ta ket thuc ham merge
	bge	$s1, $a2, endMerge		# Neu $s1 >= $a0, da duyet qua het mang thi ta ket thuc ham merge
	j	mergeloop			# Khong thi ta tiep tuc duyet qua cac phan tu tiep theo

# Ket thuc ham merge
endMerge:
	# In mang ban dau ra man hinh
	la	$a0, arr
	lw	$a1, size
	jal	printArray 
	
	# Load gia tri cua cac thanh ghi trong stack vao lai cac thanh ghi
	lw	$ra, 0($sp)		
	lw	$a0, 4($sp)			
	lw	$a1, 8($sp)			
	lw	$a2, 12($sp)		
	
	addi	$sp, $sp, 16		
	jr	$ra				
	
#########################################
# shiftElement($a0, $a1)
#########################################
# Ham shiftElement dich chuyen mang sao cho $a0 se thay the cho $a1, va cac phan tu ke tu $a1 se duoc dich sang phai 1 phan tu
# Doi so $a0: dia chi cua phan tu can dich chuyen
# Doi so $a1: dia chi cua phan tu can thay the
# Gia tri tra ve: Ham khong co gia tri tra ve
shiftElement:
	# Luu gia tri cac thanh ghi duoc dung trong ham vao stack
	addi	$sp, $sp, -8
	sw	$a0, 0($sp)
	sw	$a1, 4($sp)
	
	loopshiftElement:
	beq	$a0, $a1, endShiftElement	#dung khi $a0 cham $a1
	
	# Swap $a0 va phan tu lien truoc no
	addi	$t0, $a0, -4		
	lw	$t1, 0($a0)			
	lw	$t2, 0($t0)			
	sw	$t1, 0($t0)			
	sw	$t2, 0($a0)			
	
	addi	$a0, $a0, -4		
	j	loopshiftElement		
	
# Ket thuc ham shiftElement
endShiftElement:
	# Load gia tri cua cac thanh ghi trong stack vao lai cac thanh ghi
	lw	$a0, 0($sp)
	lw	$a1, 4($sp)
	
	addi	$sp, $sp, 8	
	jr	$ra				
	
#########################################
# printArray($a0, $a1)
#########################################
# Ham printArray se in cac phan tu cua mang ra man hinh
# Doi so $a0: dia chi cua mang
# Doi so $a1: so phan tu cua mang
# Gia tri tra ve: Ham khong co gia tri tra ve
	
printArray:
	addi	$sp,$sp,-12
	sw	$a0,8($sp)
	sw	$a1,4($sp)
	sw	$ra,0($sp)
	li	$t0,0
	loop1:
	# Dung khi t0==arr.size
	slt	$t1,$t0,$a1
	beq	$t1,$zero,end1
	# In phan tu a[i] ra man hinh
	move	$t6,$a0		#luu $a0 vi buoc tiep theo lam mat gia tri a0
	li	$v0, 1			
	sll	$t1,$t0,2
	add	$t1,$t1,$a0		
	lw	$a0,0($t1)
	syscall			
	
 	
 	# In ki tu space ra man hinh
	li $v0, 4			
	la $a0, spacechac	
	syscall				
	
	# In phan tu tiep theo ra man hinh
	move	$a0, $t6			# Load lai gia tri da luu tam tai $s6 vao lai $a0
	addi	$t0,$t0,1		
	j	loop1		
	
# Ket thuc ham printArray
	end1:
	lw	$a0,8($sp)
	lw	$a1,4($sp)
	lw	$ra,0($sp)
	addi	$sp,$sp,12
	# In ki tu xuong dong ra man hinh
	li	$v0, 4			
	la	$a0, endline			
	syscall				
	
	jr	$ra				

#########################################
