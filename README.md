  <h1>MusicBox Project Automation Script</h1>
  <p>This script automates the process of building microservices projects on your local machine. It includes checking and installing required software programs, configuring SSH access keys for GitLab, creating necessary project directories, and pulling code repositories from GitLab.</p>
  
  <h2>Prerequisites</h2>
  <p>This script requires the following programs to be installed:</p>
  <ul>
    <li>git</li>
    <li>ssh</li>
    <li>openvpn</li>
  </ul>
  <p>If any of these programs are not installed, the script will attempt to install them.</p>
  
  <h2>Configuration</h2>
  <p>Edit the script to configure the following parameters:</p>
  <ul>
    <li><code>programs</code>: List of required programs for installation.</li>
    <li><code>project_dir</code>: Location of the project directory.</li>
    <li><code>repo_base_url</code>: Base URL for GitLab repositories.</li>
    <li><code>directory_repository_map</code>: Mapping of project directories to repository URLs.</li>
  </ul>
  
  <h2>Usage</h2>
  <p>To use the script:</p>
  <ol>
    <li>Open a terminal.</li>
    <li>Navigate to the directory containing the script.</li>
    <li>Run the following command to make the script executable: <code>chmod +x git.sh</code></li>
    <li>Run the script: <code>./git.sh</code></li>
    <li>Follow the on-screen prompts to configure SSH access and install required software.</li>
  </ol>
  
  <h2>Functionality</h2>
  <ul>
    <li><strong>CheckSoftwareInstallation:</strong> Checks for required software installations and installs them if necessary.</li>
    <li><strong>SetAccessConfig:</strong> Configures SSH access for GitLab repositories.</li>
    <li><strong>InstallProgram:</strong> Installs required software programs.</li>
    <li><strong>CreateFolder:</strong> Creates project directories if they don't exist.</li>
    <li><strong>GitPullChanges:</strong> Initializes Git repositories and pulls changes from GitLab.</li>
    <li><strong>Start:</strong> Main function that orchestrates the script's execution.</li>
  </ul>
  <h2>How to Configure SSH and Transmit with GitLab over SSH? </h2>
  <p><b>Step 1: Install SSH Service</b></p>
  <pre><code>sudo apt install ssh</code></pre>
  
  <p><b>Step 2: Enable and Start SSH Service on Boot</b></p>
  <pre><code>sudo systemctl enable sshd && sudo systemctl start sshd</code></pre>
  
  <p><b>Step 3: Generate a New Access Key</b></p>
  <pre><code>
ssh-keygen -t rsa -b 4096 -C "example@example.com" # Generate a new key.
 P.S Add public key which called like as id_rsa.pub to GitLab afterward.
eval "$(ssh-agent -s)" # Run ssh-agent
ssh-add ~/.ssh/id_rsa
</code></pre>
  
 <p><b>Step 4: Use ssh-agent in Persistent Mode to Avoid Repeated Key Passphrase Prompts</b></p>
 <p>So open the configuration script ~/.bashrc using the nano text editor and add the following line:</p>
  <pre><code>
if [ -z "$SSH_AUTH_SOCK" ]; then
  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/id_rsa
fi 
</code></pre>
<p>Save the changes by pressing CTRL+O and then enter the following command to apply the changes without restarting the sessio9n:</p>
<code>
    source ~/.bashrc    
</code>  
  <p><b>Step 5: Edit SSH Configuration</b></p>
  <p>Edit the ssh_config file located at /etc/ssh/ssh_config using a text editor like nano:</p>
  <pre><code>
sudo nano /etc/ssh/ssh_config
</code></pre>
  <p>Add the following lines:</p>
  <pre><code>
Host gitlab.musicbox.local
  PreferredAuthentications publickey
  IdentityFile ~/.ssh/id_rsa
</code></pre>
  
  <p><b>Step 6: Restart SSH Service</b></p>
  <pre><code>sudo systemctl restart sshd</code></pre>
  
  <p><b>Step 7: Test the Connection</b></p>
  <pre><code>ssh -T git@gitlab.musicbox.local</code></pre>
  <p>You should receive a welcome message from GitLab.</p>
  
  <p><b>Step 8: Run Your Script</b></p>
  <pre><code>./git.sh</code></pre>
  <p><em>Developed by Sergey Zhyltsov</em></p>

<hr>
<h1>Скрипт автоматизации проекта MusicBox</h1>
<p>Этот скрипт автоматизирует процесс создания проектов микросервисов на вашем локальном компьютере. Он включает в себя проверку и установку необходимых программ, настройку доступа SSH для GitLab, создание необходимых директорий проекта и загрузку кодовых репозиториев из GitLab.</p>

<h2>Предварительные требования</h2>
<p>Для работы скрипта требуются следующие установленные программы:</p>
<ul>
  <li>git</li>
  <li>ssh</li>
  <li>openvpn</li>
</ul>
<p>Если какая-либо из этих программ не установлена, скрипт попытается их установить.</p>

<h2>Настройка</h2>
<p>Отредактируйте скрипт для настройки следующих параметров:</p>
<ul>
  <li><code>programs</code>: Список необходимых программ для установки.</li>
  <li><code>project_dir</code>: Путь к директории проекта.</li>
  <li><code>repo_base_url</code>: Базовый URL для репозиториев GitLab.</li>
  <li><code>directory_repository_map</code>: Соответствие директорий проекта URL репозиториев.</li>
</ul>

<h2>Использование</h2>
<p>Для использования скрипта:</p>
<ol>
  <li>Откройте терминал.</li>
  <li>Перейдите в директорию, содержащую скрипт.</li>
  <li>Запустите следующую команду, чтобы сделать скрипт исполняемым: <code>chmod +x git.sh</code></li>
  <li>Запустите скрипт: <code>./git.sh</code></li>
  <li>Следуйте инструкциям на экране для настройки доступа SSH и установки необходимого программного обеспечения.</li>
</ol>

<h2>Функциональность</h2>
<ul>
  <li><strong>CheckSoftwareInstallation:</strong> Проверяет установку необходимого программного обеспечения и устанавливает его при необходимости.</li>
  <li><strong>SetAccessConfig:</strong> Настраивает доступ SSH для репозиториев GitLab.</li>
  <li><strong>InstallProgram:</strong> Устанавливает необходимые программы.</li>
  <li><strong>CreateFolder:</strong> Создает директории проекта, если они не существуют.</li>
  <li><strong>GitPullChanges:</strong> Инициализирует репозитории Git и загружает изменения из GitLab.</li>
  <li><strong>Start:</strong> Основная функция, оркестрирующая выполнение скрипта.</li>
</ul>

<h2>Как настроить SSH и передавать данные через GitLab с помощью SSH </h2>
<p><b>Шаг 1: Установите SSH-сервис</b></p>
<pre><code>sudo apt install ssh</code></pre>

<p><b>Шаг 2: Включите и запустите SSH-сервис при загрузке</b></p>
<pre><code>sudo systemctl enable sshd && sudo systemctl start sshd</code></pre>

<p><b>Шаг 3: Создайте новый ключ доступа</b></p>
<pre><code>
ssh-keygen -t rsa -b 4096 -C "example@example.com" # Создайте новый ключ.
 P.S Добавьте открытый ключ с именем id_rsa.pub в GitLab после этого.
eval "$(ssh-agent -s)" # Запустите ssh-agent
ssh-add ~/.ssh/id_rsa
</code></pre>

<p><b>Шаг 4: Используйте ssh-agent в постоянном режиме, чтобы избежать повторных запросов пароля для ключа</b></p>
<p>Откройте файл конфигурации ~/.bashrc с помощью текстового редактора nano и добавьте следующую строку:</p>
<pre><code>
if [ -z "$SSH_AUTH_SOCK" ]; then
  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/id_rsa
fi 
</code></pre>

<p>Сохраните изменения, нажав CTRL+O, а затем введите следующую команду, чтобы применить изменения без перезапуска сессии:</p>
<code>
    source ~/.bashrc    
</code>  

<p><b>Шаг 5: Редактирование конфигурации SSH</b></p>
<p>Отредактируйте файл ssh_config, расположенный в /etc/ssh/ssh_config, используя текстовый редактор, например nano:</p>
<pre><code>
sudo nano /etc/ssh/ssh_config
</code></pre>

<p>Добавьте следующие строки:</p>
<pre><code>
Host gitlab.musicbox.local
  PreferredAuthentications publickey
  IdentityFile ~/.ssh/id_rsa
</code></pre>

<p><b>Шаг 6: Перезапустите SSH-сервис</b></p>
<pre><code>sudo systemctl restart sshd</code></pre>

<p><b>Шаг 7: Проверьте соединение</b></p>
<pre><code>ssh -T git@gitlab.musicbox.local</code></pre>
<p>Вы должны получить приветственное сообщение от GitLab.</p>

<p><b>Шаг 8: Запустите ваш скрипт</b></p>
<pre><code>./git.sh</code></pre>
<p><em>Разработано Сергеем Жилцовым</em></p>
