file_path = "challenge.bin"

function parse_input(file_path=file_path)
    out = read(file_path)
    return [Int(UInt16(out[i+1]) << 8 | UInt16(out[i])) for i in 1:2:length(out)-1]
end
file = parse_input()


function processor(input=file)
    i = 1
    stack = []
    registry = zeros(Int, 8)
    debug_count = 0
    logging = false
    while true 
        debug_count += 1
        if debug_count == 500000
            registry[8] =1
        end
        if i == 5446
            logging = true
        end
        if input[i] == 0
            break
        elseif input[i] == 1
            registry[input[i+1]-32767] = reg_check(input[i+2], registry)
            i += 3
        elseif input[i] == 2
            push!(stack, reg_check(input[i+1], registry))
            i += 2
        elseif input[i] == 3
            if length(stack) == 0
                break
            else
                registry[input[i+1]-32767] = pop!(stack)
            end
            i += 2
        elseif input[i] == 4
            if reg_check(input[i+2], registry) == reg_check(input[i+3], registry)

                registry[input[i+1]-32767] = 1
            else
                registry[input[i+1]-32767] = 0
            end
            i += 4
        elseif input[i] == 5
            if reg_check(input[i+2], registry) > reg_check(input[i+3], registry)
                registry[input[i+1]-32767] = 1
            else
                registry[input[i+1]-32767] = 0
            end
            i += 4
        elseif input[i] == 6
            i = reg_check(input[i+1], registry) +1
        elseif input[i] == 7
            i = reg_check(input[i+1], registry) != 0 ? reg_check(input[i+2], registry) +1 : i + 3
        elseif input[i] == 8
            i = reg_check(input[i+1], registry) == 0 ? reg_check(input[i+2], registry) + 1 : i + 3
        elseif input[i] == 9
            registry[input[i+1]-32767] = (reg_check(input[i+2], registry) + reg_check(input[i+3], registry)) % 32768
            i += 4
        elseif input[i] == 10
            registry[input[i+1]-32767] = (reg_check(input[i+2], registry) * reg_check(input[i+3], registry)) % 32768
            i += 4
        elseif input[i] == 11
            registry[input[i+1]-32767] = (reg_check(input[i+2], registry) % reg_check(input[i+3], registry))
            i += 4
        elseif input[i] == 12
            registry[input[i+1]-32767] = (reg_check(input[i+2], registry) & reg_check(input[i+3], registry))
            i += 4
        elseif input[i] == 13
            registry[input[i+1]-32767] = (reg_check(input[i+2], registry) | reg_check(input[i+3], registry))
            i += 4
        elseif input[i] == 14
            registry[input[i+1]-32767] = reg_check(bitwise_inverse(reg_check(input[i+2], registry)), registry)
            i += 3
        elseif input[i] == 15
            registry[input[i+1]-32767] = input[reg_check(input[i+2], registry)+1]
            i += 3
        elseif input[i] == 16
            input[reg_check(input[i+1], registry)+1] = reg_check(input[i+2], registry)
            i += 3
        elseif input[i] == 17
            push!(stack, i+1)
            i = reg_check(input[i+1], registry) +1
        elseif input[i] == 18
            if length(stack) == 0
                break
            else
                i = pop!(stack) + 1
            end
        elseif input[i] == 19
            print(Char(reg_check(input[i+1], registry)))
            i += 2
        elseif input[i] == 20
            terminal_input = read(stdin, Char)
            registry[input[i+1]-32767] = Int(terminal_input)
            i += 2
        elseif input[i] == 21
            i +=1
            continue
        else
            println("Unknown instruction: $(input[i])")
            break
        end
    end
end
function reg_check(x, registry=registry)
    if x <= 65535 && x >= 32776
        return false
    elseif 32768 <= x <= 32775
        return registry[x-32767]
    else
        return x
    end
end
bitwise_inverse(n) = parse(Int, bitstring(Int16(~n))[2:end], base =2)



@show processor()
#get the elements of file that are less than 21

