//
//  Opcodes.swift
//  certificates-ios-client
//
//  Created by Jonikorjk on 30.06.2023.
//

import Foundation

enum Opcode: String {
    case OP_0
    case OP_PUSHDATA1
    case OP_PUSHDATA2
    case OP_PUSHDATA4
    case OP_1NEGATE
    case OP_RESERVED
    case OP_1
    case OP_2
    case OP_3
    case OP_4
    case OP_5
    case OP_6
    case OP_7
    case OP_8
    case OP_9
    case OP_10
    case OP_11
    case OP_12
    case OP_13
    case OP_14
    case OP_15
    case OP_16

    // control
    case OP_NOP
    case OP_VER
    case OP_IF
    case OP_NOTIF
    case OP_VERIF
    case OP_VERNOTIF
    case OP_ELSE
    case OP_ENDIF
    case OP_VERIFY
    case OP_RETURN

    // stack ops
    case OP_TOALTSTACK
    case OP_FROMALTSTACK
    case OP_2DROP
    case OP_2DUP
    case OP_3DUP
    case OP_2OVER
    case OP_2ROT
    case OP_2SWAP
    case OP_IFDUP
    case OP_DEPTH
    case OP_DROP
    case OP_DUP
    case OP_NIP
    case OP_OVER
    case OP_PICK
    case OP_ROLL
    case OP_ROT
    case OP_SWAP
    case OP_TUCK

    // splice ops
    case OP_CAT
    case OP_SUBSTR
    case OP_LEFT
    case OP_RIGHT
    case OP_SIZE

    // bit logic
    case OP_INVERT
    case OP_AND
    case OP_OR
    case OP_XOR
    case OP_EQUAL
    case OP_EQUALVERIFY
    case OP_RESERVED1
    case OP_RESERVED2

    // numeric
    case OP_1ADD
    case OP_1SUB
    case OP_2MUL
    case OP_2DIV
    case OP_NEGATE
    case OP_ABS
    case OP_NOT
    case OP_0NOTEQUAL
    case OP_ADD
    case OP_SUB
    case OP_MUL
    case OP_DIV
    case OP_MOD
    case OP_LSHIFT
    case OP_RSHIFT
    case OP_BOOLAND
    case OP_BOOLOR
    case OP_NUMEQUAL
    case OP_NUMEQUALVERIFY
    case OP_NUMNOTEQUAL
    case OP_LESSTHAN
    case OP_GREATERTHAN
    case OP_LESSTHANOREQUAL
    case OP_GREATERTHANOREQUAL
    case OP_MIN
    case OP_MAX
    case OP_WITHIN

    // crypto
    case OP_RIPEMD160
    case OP_SHA1
    case OP_SHA256
    case OP_HASH160
    case OP_HASH256
    case OP_CODESEPARATOR
    case OP_CHECKSIG
    case OP_CHECKSIGVERIFY
    case OP_CHECKMULTISIG
    case OP_CHECKMULTISIGVERIFY

    // expansion
    case OP_NOP1
    case OP_CHECKLOCKTIMEVERIFY
    case OP_CHECKSEQUENCEVERIFY
    case OP_NOP4
    case OP_NOP5
    case OP_NOP6
    case OP_NOP7
    case OP_NOP8
    case OP_NOP9
    case OP_NOP10

    // Opcode added by BIP 342 (Tap
    case OP_CHECKSIGADD
    case OP_INVALIDOPCODE
}
