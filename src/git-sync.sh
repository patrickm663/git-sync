#! bin/bash

# Author: Patrick Moehrke
# License: BSD 3-Clause

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

pull_repo () {
  echo -e "Repo: " $(echo $1 | sed "s/.git//") 
  read -n 1 -p "Would you like to check for updates? [y/n] " confirmation;
  if [ "$confirmation" = "y" ]
  then
    echo -e " "
    cd $1
    cd ../
    STATUS=$(git remote update; git status -uno | grep -o "Your branch is up to date")
    if [ -z "$STATUS" ]
    then
      read -n 1 -p "Would you like to apply updates? [y/n] " confirmation;
      if [ "$confirmation" = "y" ]
      then
	echo -e " "
	git pull
      fi
    else
      echo -e $STATUS
    fi
  fi
  echo -e " "
  cd ~/
}

main () {
  cd ~/
  for repo in $(find -name ".git")
  do
    pull_repo $repo
  done
}

main
