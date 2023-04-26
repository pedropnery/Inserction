# Codigo Base: https://gist.github.com/benwrk/9d2c8c735885348a270b e https://studylib.net/doc/8545941/home-work-%23-4-solution
# Equipe: Marco Antonio e Pedro Nery
# Tema: InsertionSort

.data
espaço:		.asciiz " "
novaLinha:	.asciiz	"\n"
vetor:		.word	0 : 10	# tamanho do vetor
contagem:	.word	4	# contagem em tempo real dos elementos dentro do vetor.
tamanho:	.asciiz	"Digite o tamanho do vetor (Entre 0 e 10): "
valor:		.asciiz	"Digite o valor: "
mostrarVetor:	.asciiz "Vetor digitado:"
mostrarVetorOrdenado:	.asciiz "Vetor ordenado:"

.text
.globl	main
main:
entradaTamanho:
	li	$v0, 4			# 4 = impressao de string no syscall.
	la	$a0, tamanho		# registro do argumento entradaTamanho no $a0.
	syscall	
	li	$v0, 5			# 5 = leitura de inteiro no syscall.
	syscall				
	la	$t0, contagem		# carrega o endereço da contagem de elementos no $t0 (valor temporario). 
	sw	$v0, 0($t0)		# retorna o valor da expressao v$0 na contagem.
	li	$v0, 4			
	la	$a0, novaLinha		# printa uma nova linha (\n) no registrador $a0.
	syscall
	la	$t0, vetor		# carrega o vetor no registrador $t0.
	lw	$t1, contagem		# lança a contagem de elementos no registrado $t1.
	li	$t2, 0			# usa um registrador temporario com valor 0 que sera usado no loop.
	
loopEntradaDeValores:
	bge	$t2, $t1, loopFinalDaEntrada	# while que compara o registrador $t1 com $t2 ($t2 < $t1).
	li	$v0, 4			
	la	$a0, valor 		# carrega o valor digitado no registrador $a0.
	syscall				
	li	$v0, 5			
	syscall				
	sw	$v0, 0($t0)		# uso do store word que retorna o valor do syscall no vetor.

	addi	$t0, $t0, 4		# incrementa o ponteiro do vetor em 4.
	addi	$t2, $t2, 1		# incrementa o loop em 1.
	j	loopEntradaDeValores	# volta pro inicio do loop.
	
loopFinalDaEntrada:
	li	$v0, 4			
	la	$a0, novaLinha		
	syscall
	li	$v0, 4
	la	$a0, mostrarVetor
	syscall
	jal	print			# chama pra funcao print, salva as instruçoes em um registrador e volta.
	
# carregamento e entrada separadas caso ocorra erro no loop
carregaLoopVetor:
	la	$t0, vetor		# carrega o vetor no registrador $t0.
	lw	$t1, contagem		# carrega a contagem de elementos no $t1.
	li	$t2, 1			# usa um registrador temporario com valor 1 que sera usado no loop.
entradaLoopVetor:
	la	$t0, vetor		
	bge	$t2, $t1, finalizaOrdenacao	
	move	$t3, $t2		# copia o valor do registrador $t2 para o $t3.
	
loopOrdenacao:
	la	$t0, vetor		
	mul	$t5, $t3, 4		# multiplica o registrador $t3 com 4, e carrega o valor no registrador $t5
	add	$t0, $t0, $t5		# bota o endereço do vetor no registrador $t5, no qual eh o endereço multiplicador por 4.
	ble	$t3, $zero, incrementoLoopOrdenacao	# compara enquanto o regitrador for maior que zero (t3 > 0).
	lw	$t7, 0($t0)		# carrega o vetor da posicao[$t3] (do valor posto no $t3) para o registrador $t7.
	lw	$t6, -4($t0)		# carrega o vetor da posicao[$t3 - 1] para o registrador $t6.
	bge	$t7, $t6, incrementoLoopOrdenacao	# compara as posicoes dos vetores.
	lw	$t4, 0($t0)
	sw	$t6, 0($t0)
	sw	$t4, -4($t0)
	subi	$t3, $t3, 1
	j	loopOrdenacao		# volta pro inicio do loop.
	
incrementoLoopOrdenacao:
	addi	$t2, $t2, 1		# incrementa o loop em 1.
	j	entradaLoopVetor	# volta pro inicio do loop.
	
finalizaOrdenacao:
	li	$v0, 4			
	la	$a0, novaLinha		
	syscall
	li	$v0, 4
	la	$a0, mostrarVetorOrdenado
	syscall
	jal	print			# chama a funcao print.
	
exit:
	li	$v0, 10			# 10 = termina a execucao.
	syscall				

print:
# nova linha fora do loop
	li	$v0, 4
	la	$a0, novaLinha
	syscall
	la	$t0, vetor
	lw	$t1, contagem
	li	$t2, 0
	
loopPrintVetor:
	bge	$t2, $t1, encerraPrint
	li	$v0, 1
	lw	$a0, 0($t0)
	syscall
	li	$v0, 4
	la	$a0, espaço
	syscall
	addi	$t0, $t0, 4
	addi	$t2, $t2, 1
	j	loopPrintVetor
	
encerraPrint:
	jr	$ra
