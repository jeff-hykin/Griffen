


# griffen install for mac
def installEverything
    #
    # xcode tools 
    #
        `xcode-select --install`

    #
    # homebrew
    #
        curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install

        #check homebrew
        response = `brew doctor`
        homebrew_installed = (  nil != response.match(/Your system is ready to brew/)  )

        # FIXME, what to do if homebrew didn't install
        if not homebrew_installed
            puts "I couldn't get homebrew to install for some reason :/"
            return 
        end#if

    #
    # node.js
    #

        output = `brew install node`

        # Does path need to be fixed?
            # lots of times when installing node
            # the node command still wont work because the 
            # computer doesnt know where the command is
            # so the path (where your computer looks) has to be manually updated
            path_fix_is_needed = output.match(/If you need to have this software first in your PATH run:/)
            path_fix = output.match(/If you need to have this software first in your PATH run:\n\s+(?<FirstPathCommand>.+)\n(?<SecondPathCommand>.+)/)
            # check for error 
                if path_fix_is_needed and (path_fix == nil)
                    puts "There is a problem :/"
                    puts "Homebrew was installing node"
                    puts "But (as usual) $PATH needed to be updated manually"
                    puts "But the regex couldn't find how to update the path"
                    puts "here is what homebrew said:"
                    puts output.gsub(/(\n|^)/,"    \n")
                    return
                end#if
            # try to add stuff to bash profile
            if path_fix != nil
                first_command = path_fix["FirstPathCommand"]
                second_command = path_fix["SecondPathCommand"]
                # extract the actual path
                first_command.sub(/^echo '/,"")
                first_command.sub(/' >> ~\/\.bash_profile$/,"")
                second_command.sub(/^echo '/,"")
                second_command.sub(/' >> ~\/\.bash_profile$/,"")
                # FIXME, check and see if those locations are already in the path/ .bash_profile
                # add those commands to the bash profile 
                bash_profile = File.open(Dir.home+'/.bash_profile','a')
                exact_install_string = "# When Griffen was installing node (through homebrew)\n# the PATH needed to be extended to include the node and npm commands\n# so the next two lines were added here in order to do that\n#{first_command}\n#{second_command}"
                # FIXME store exact_install_string somewhere so that uninstalls can be done easily
                bash_profile.puts(exact_install_string)
                bash_profile.close
            end#if 

        # check node
        response = `node -v`
        node_installed = (  nil != response.match(/v\d+\.\d+/)  )
        # check npm
        response = `npm -v`
        npm_installed = ( nil != response.match(/\d+\.\d+/))

        # FIXME, what to do if node didn't install
        if not node_installed or not npm_installed
            puts "I couldn't get node.js installed :/"
            return
        end#if
    #
    # pug, SASS, CoffeeScript, Electron, Electron-Dev
    #
        `npm install -g pug`
        `npm install -g sass`
        `npm install -g coffeescript`
        `npm install -g electron`
        `npm install -g electron-dev`
end#installEverything
installEverything
