class Gui < FXMainWindow

	def initialize(app)
		
		# Initialize base class first
    super(app, "Plauschangriff Downloader", :opts => DECOR_ALL, :width => 460, :height => 170)
		
		# Initialize other classes
		
		begin
		  @xml = Xml.new
		rescue StandardError => e
		  #@errormessage.error(self, MBOX_OK, "Error", "Test")
		  errorbox = FXMessageBox.new(self, "Error", "#{e}", :opts => MBOX_OK)
		  errorbox.width  = 600
		  errorbox.height = 200
		  errorbox.place(PLACEMENT_SCREEN)
		  errorbox.show		  		  
		end
		@prepare = Prepare.new
				
		## Create GUI
		
		topFrame = FXHorizontalFrame.new(self)
		topFrameLeft = FXVerticalFrame.new(topFrame)
		topFrameRight = FXVerticalFrame.new(topFrame, :padLeft => 25)
		
		lbl1 = FXLabel.new(topFrameLeft, 'Select podcasts', nil, LAYOUT_LEFT)
    lbl2 = FXLabel.new(topFrameRight, ' ', nil, LAYOUT_LEFT)
    		
		@list1 = FXList.new(topFrameLeft, :opts => LAYOUT_FIX_WIDTH|LAYOUT_FIX_HEIGHT|LIST_EXTENDEDSELECT|LIST_MULTIPLESELECT, :width => 350, :height => 80)
    if(defined? @xml)
      @list1.fillItems(@xml.getPodcastNames)
    end
		
		btnDownload = FXButton.new(topFrameRight, 'Download', :opts => FRAME_RAISED|FRAME_THICK|LAYOUT_FILL_X)
		btnExit = FXButton.new(topFrameRight, 'Exit', :opts => FRAME_RAISED|FRAME_THICK|LAYOUT_FILL_X)
		
		@lbl3 = FXLabel.new(topFrameLeft, 'Waiting...', nil, JUSTIFY_LEFT|LAYOUT_FIX_WIDTH, :width => 350)
		@progressbar =  FXProgressBar.new(topFrameLeft, :opts => LAYOUT_FIX_WIDTH|PROGRESSBAR_HORIZONTAL|PROGRESSBAR_NORMAL|PROGRESSBAR_PERCENTAGE, :width => 350)
		@progressbar.barColor = Fox.FXRGB(152, 251, 152)		
		
		btnExit.connect(SEL_COMMAND) { exit }
		btnDownload.connect(SEL_COMMAND) { Thread.new {start} }
				
	end
	
	def download(url, name)
		open(name, 'wb') do |file|
			open(url, :progress_proc => proc { |step|					
					@progressbar.progress = step	
				}) do |uri|
				file.write(uri.read)
			end
		end
	end
	
	
	def start
		@list1.each do |item|
			if(item.selected?)
				url = @xml.getDownloadLink(item)
				@progressbar.total = @prepare.getSize(url)
				name = "Rocket Beans Plauschangriff - " + item.to_s + ".mp3"
				@lbl3.text = "Downloading: " + item.to_s + ".mp3"
				download(url, @prepare.sanitize(name))
			end
		end		
	end


	def create
		super
		show(PLACEMENT_SCREEN)
	end
end